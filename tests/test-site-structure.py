#!/usr/bin/env python3
"""Validate built HTML destinations, fragment links, landmarks, and referrals."""
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit

ROOT = Path(__file__).resolve().parents[1] / "dist"
if not ROOT.is_dir():
    raise SystemExit("dist/ is missing; run ./scripts/build-site.sh before the built-site structure test")


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__()
        self.path, self.ids, self.links, self.assets, self.images = path, [], [], [], []
        self.primary_links, self.more_menus = [], []
        self.lang = None
        self.primary_nav_depth = 0
        self.tags = Counter()
        self.feed(path.read_text())

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        self.tags[tag] += 1
        if tag == "html":
            self.lang = attrs.get("lang")
        if tag == "nav" and "nav" in attrs.get("class", "").split():
            self.primary_nav_depth += 1
        if tag == "div" and "nav-more-menu" in attrs.get("class", "").split():
            self.more_menus.append(attrs)
        if "id" in attrs:
            self.ids.append(attrs["id"])
        if tag == "a" and "href" in attrs:
            self.links.append(attrs)
            if self.primary_nav_depth:
                self.primary_links.append(attrs)
        if tag == "img":
            self.images.append(attrs)
        if tag in ("img", "script") and "src" in attrs:
            self.assets.append(attrs["src"])
        if tag == "link" and attrs.get("rel") == "stylesheet":
            self.assets.append(attrs["href"])

    def handle_endtag(self, tag):
        if tag == "nav" and self.primary_nav_depth:
            self.primary_nav_depth -= 1


pages = {path.relative_to(ROOT).as_posix(): Page(path) for path in ROOT.rglob("*.html")}
assert "thesis/index.html" in pages, "Thesis missing from production build"
expected_current = {
    "recommendations/index.html": "/recommendations/",
    "thesis/index.html": "/thesis/",
    "playbook/index.html": "/playbook/",
    "monero/index.html": "/monero/",
    "plasma/index.html": "/plasma/",
    "aave/index.html": "/aave/",
    "docs/index.html": "/docs/",
    "projects/index.html": "/projects/",
    "projects/gmcp/index.html": "/projects/",
    "labs/index.html": "/labs/",
    "labs/dsx-air/index.html": "/labs/",
    "infrastructure/index.html": "/infrastructure/",
    "contact/index.html": "/contact/",
}
failures = []
for name, page in pages.items():
    if page.lang != "en":
        failures.append(f"{name}: document must declare lang=\"en\"")
    if len(page.more_menus) != 1 or page.more_menus[0].get("role") != "group" or page.more_menus[0].get("aria-label") != "More navigation":
        failures.append(f"{name}: More navigation group is missing its accessible label")
    current_links = [link for link in page.primary_links if link.get("aria-current") == "page"]
    if len(current_links) > 1:
        failures.append(f"{name}: primary navigation has duplicate current-page links")
    expected_href = expected_current.get(name)
    if expected_href is None:
        if current_links:
            failures.append(f"{name}: unexpected current-page navigation link")
    elif len(current_links) != 1 or current_links[0].get("href") != expected_href:
        failures.append(f"{name}: expected exactly one current-page link to {expected_href}")
    for tag in ("main", "h1"):
        if page.tags[tag] != 1:
            failures.append(f"{name}: expected one {tag}, got {page.tags[tag]}")
    for identity, count in Counter(page.ids).items():
        if count > 1:
            failures.append(f"{name}: duplicate id {identity}")
    for href in [link["href"] for link in page.links] + page.assets:
        url = urlsplit(urljoin("https://www.encryptedguru.com/" + name, href))
        if url.scheme != "https" or url.netloc != "www.encryptedguru.com":
            continue
        target = unquote(url.path).lstrip("/")
        if target.endswith("/") or not target:
            target += "index.html"
        if not (ROOT / target).is_file():
            failures.append(f"{name}: missing destination {href}")
        elif url.fragment and target in pages and unquote(url.fragment) not in pages[target].ids:
            failures.append(f"{name}: missing fragment {href}")
    for link in page.links:
        if link.get("target") == "_blank" and "noopener" not in link.get("rel", ""):
            failures.append(f"{name}: external new-tab link missing noopener")
    for image in page.images:
        if "alt" not in image:
            failures.append(f"{name}: image missing alt attribute")

referrals = pages["recommendations/index.html"]
for identity in ("plasma-one", "fluid", "bitfinex", "binance", "aave"):
    if identity not in referrals.ids:
        failures.append(f"recommendations: missing deep-link target {identity}")
for url in ("https://fluid.io/9745/lending", "https://www.bitfinex.com/sign-up?refcode=noAVQ3EXo",
            "https://www.binance.com/register?ref=EGURU", "https://aave.com/app/r/999F66"):
    links = [link for link in referrals.links if link["href"] == url]
    if len(links) != 1 or "sponsored" not in links[0].get("rel", ""):
        failures.append(f"recommendations: missing or undisclosed provider link {url}")
if sum(link["href"] == "https://rabby.io/" for link in referrals.links) != 1:
    failures.append("recommendations: missing official Rabby control entry")
if failures:
    raise SystemExit("\n".join(failures))
print(f"Structure passed: {len(pages)} pages; destinations, fragments, landmarks, and referral integrity.")
