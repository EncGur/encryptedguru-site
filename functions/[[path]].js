const retiredAssets = new Map([
  ["/logo.png", "/eg-mark.png"],
  ["/favicon-32x32.png", "/eg-mark-32.png"],
  ["/favicon.ico", "/eg-mark.ico"],
  ["/apple-touch-icon.png", "/eg-mark-180.png"],
]);

export function onRequest({ request }) {
  const pathname = new URL(request.url).pathname;
  const replacement = retiredAssets.get(pathname);

  if (replacement) {
    return new Response(null, {
      status: 302,
      headers: {
        "Cache-Control": "no-store",
        "Location": replacement,
        "X-Robots-Tag": "noindex",
      },
    });
  }

  return new Response("Not Found\n", {
    status: 404,
    headers: {
      "Cache-Control": "no-store",
      "Content-Type": "text/plain; charset=utf-8",
      "X-Robots-Tag": "noindex",
    },
  });
}
