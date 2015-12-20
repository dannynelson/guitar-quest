// will be served to browser...

// We won't use Express (http://expressjs.com/) in this app since we don't really need
// it to serve a simple html page.

// "http" module will be used to create the http server
import http from 'http'
import React from 'react'

// We create our main application server here. It will serve the same page on all URIs
// so you won't find any route specific logic below (except for rejecting favicon request)
var server = http.createServer(function(req, res) {

  // Forget this, it's just to avoid serving anything when the browser automatically
  // requests favicon (if not, this server would send back an html page).
  if (req.url.match('favicon.ico')) {
    return res.end()
  }

  // And of course, here is our Application HTML that we're sending back to the browser.
  // Nothing special here except the URI of our application JS bundle that points to our
  // webpack dev server (located at http://localhost:5051)
  res.write(
    `<!DOCTYPE html>
    <html>
      <head>
        <meta charSet="utf-8" />
      </head>
      <body>
        <div id="app-wrapper"></div>
        <script type="text/javascript" src="http://localhost:5051/static/bundle.js"></script>
      </body>
    </html>`
  )

  res.end()
})

export default server
