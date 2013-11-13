express = require 'express'
sanitizer = require 'sanitizer'

operations = require './lib/operations'

template = (message, subtitle) -> '
<html>
  <head>
    <title>Khan As A Service (KHANAAS)</title>
    <meta charset="utf-8">
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet">
  </head>

  <body background="'+subtitle+'" style="background-size: 100%; margin-top:40px;">
        <h1 style="padding-left: .2em; margin-top: .5em; font-size: 15em; color: white;">'+sanitizer.escape(message)+Array(100).join(sanitizer.escape(message)[sanitizer.escape(message).length-1])+'</h1>
  </body>
</html>'

dooutput = (res, message, subtitle) ->
  res.format
    "text/plain": ->
      res.send "#{message} #{subtitle}"
    "application/json": ->
      res.send JSON.stringify { message: message, subtitle: subtitle }
    "text/html": ->
      res.send template(message,subtitle)

app = express()
app.use(express.bodyParser())
app.use(express.methodOverride())

app.use (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  next()

app.use(app.router)
app.use(express.static('./public'))
app.use (req, res) ->
  res.sendfile("./public/index.html")

app.options "*", (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  res.end()

app.get '/kirk/:name', (req, res) ->
  message = "#{req.params.name}".toUpperCase()
  subtitle = "/kirk.jpg"
  dooutput(res, message, subtitle)

app.get '/spock/:name', (req, res) ->
  message = "#{req.params.name}".toUpperCase()
  subtitle = "/spock.jpg"
  dooutput(res, message, subtitle)

###
  Additional routes should go above the catch all /:thing/ route

app.get '/:thing/:from', (req, res) ->
  message = "Fuck #{req.params.thing}."
  subtitle = "- #{req.params.from}"
  dooutput(res, message, subtitle)
###

operations(app)

port = process.env.PORT || 5000
app.listen port
console.log "KHANAAS Started on port #{port}"
