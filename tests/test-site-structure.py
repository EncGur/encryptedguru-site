#!/usr/bin/env python3
"""Validate built HTML destinations, fragment links, landmarks, and referrals."""
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit

ROOT = Path(__file__).resolve().parents[1] / "dist"


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__()
        self.path, self.ids, self.links, self.assets = path, [], [], []
        self.tags = Counter()
        self.feed(path.read_text())

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        self.tags[tag] += 1
        if "id" in attrs:
            self.ids.append(attrs["id"])
        if tag == "a" and "href" in attrs:
            self.links.append(attrs)
        if tag in ("img", "script") and "src" in attrs:
            self.assets.append(attrs["src"])
        if tag == "link" and attrs.get("rel") == "stylesheet":
            self.assets.append(attrs["href"])


pages = {path.relative_to(ROOT).as_posix(): Page(path) for path in ROOT.rglob("*.html")}
assert "thesis/index.html" in pages, "Thesis missing from production build"
failures = []
for name, page in pages.items():
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

referrals = pages["recommendations/index.html"]
for identity in ("plasma-one", "bitfinex", "binance", "aave"):
    if identity not in referrals.ids:
        failures.append(f"recommendations: missing deep-link target {identity}")
for url in ("https://www.bitfinex.com/sign-up?refcode=noAVQ3EXo",
            "https://www.binance.com/register?ref=EGURU", "https://aave.com/app/r/999F66"):
    links = [link for link in referrals.links if link["href"] == url]
    if len(links) != 1 or "sponsored" not in links[0].get("rel", ""):
        failures.append(f"recommendations: missing or undisclosed provider link {url}")
if failures:
    raise SystemExit("\n".join(failures))
print(f"Structure passed: {len(pages)} pages; destinations, fragments, landmarks, and referral integrity.")
