// I won't detail Webpack Dev Server and React Hot Loader setup here since it's done pretty
// well in React Hot Loader's docs.
import server from './server'
import webpackDevServer from './webpack-dev-server'
// We request the main server of our app to start it from this file.

// Change the port below if port 5050 is already in use for you.
// if port equals X, we'll use X for server's port and X+1 for webpack-dev-server's port
const port = 5050

// Start our webpack dev server...
webpackDevServer.listen(port)
// ... and our main app server.
server.listen(port)

console.log(`Server is listening on http://127.0.0.1:${port}`)

// Go to 12_src/src/server.js...

// Go to next tutorial: 13_final-words.js
