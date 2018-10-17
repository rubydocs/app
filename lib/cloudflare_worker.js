addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const match = request.url.match(/\/d\/([^?]+)(\?.+)?/);
  let fetchable;

  if (match) {
    let doc   = match[1];
    let query = match[2] || '';

    // Redirect to latest if necessary.
    latestMatch = doc.match(/^([^/]+)-latest/);
    if (latestMatch) {
      const latest = await LATEST.get(latestMatch[1]);
      let newUrl = request.url.replace(/[^/]+-latest/, latest);
      return Response.redirect(newUrl, 302);
    }

    // Redirect to URL with trailing slash if necessary.
    if (!doc.includes('/')) {
      let newUrl = request.url.replace(doc, doc + '/');
      return Response.redirect(newUrl, 301);
     }

    if (doc.endsWith('/'))
      doc += 'index.html';
    fetchable = `http://d3eo0xoa109f6x.cloudfront.net/${doc}${query}`;
  } else {
    fetchable = request;
  }

  const response = await fetch(fetchable);
  return response;
}
