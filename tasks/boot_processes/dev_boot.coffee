###
Run processes in procfile
###

process.env.NODE_ENV ||= 'development'

childProcess = require 'child_process'
path = require 'path'
byline = require 'byline'
fs = require 'fs'

processes = {}
contents = fs.readFileSync path.resolve(process.cwd(), 'Procfile'), {encoding: 'utf8'}
for procLine in contents.split('\n') when procLine.length
  [procName, procPath] = procLine.split(':').map((part) -> part.trim())
  processes[procName] = procPath

for name, command of processes
  do (name, command) ->
    entryPoint = command.split(' ')[1]    # expecting 'coffee FILE'
    entryPoint = path.resolve(process.cwd(), entryPoint)
    child = childProcess.spawn require.resolve('coffee-script/bin/coffee'), [entryPoint],
      stdio: [process.stdin, 'pipe', 'pipe']

    ['stdout', 'stderr'].forEach (fd) ->
      byLineStream = byline child[fd]
      byLineStream.on 'data', (line) ->
        process[fd].write "[#{name}] " + line + "\n"

    # kill children when parent dies (e.g. when nodemon restarts the app)
    ['exit', 'SIGINT', 'SIGTERM'].forEach (eventName) ->
      process.on eventName, ->
        try child.kill()
