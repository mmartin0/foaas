express = require 'express'
sanitizer = require 'sanitizer'
ops = require './lib/operations'
path = require 'path'

template = (message, image) -> '
<html>
  <head>
    <title>Khan As A Service (KHANAAS)</title>
    <meta charset="utf-8">
    <style>
        span#message {
        	font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;
        	padding-left: .2em;
        	font-weight: bold;
        	color: white;
        	font-size: 10em;
        	display: inline-block;
        	white-space: nowrap;
        }
	</style>
	<script>
	  (function(i,s,o,g,r,a,m){i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,"script","//www.google-analytics.com/analytics.js","ga");

	  ga("create", "UA-45781322-1", "khanaas.com");
	  ga("send", "pageview");

	</script>
  </head>
  <body background="'+image+'" style="background-size: 100%; margin-top:40px;">
        <span id="message">'+message+'</span>
  </body>
</html>'

dooutput = (res, message, image) ->
  res.format
    "text/plain": ->
      res.send "#{message} #{image}"
    "application/json": ->
      res.send JSON.stringify { message: message, image: image }
    "text/html": ->
      res.send template(message,image)

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
app.use(express.favicon(path.join(__dirname, 'public/images/favicon.ico'))); 
app.use (req, res) ->
  res.sendfile("./public/index.html")

app.options "*", (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  res.end()

app.get '/kirk/:message', (req, res) ->
  message = ops.khan("#{req.params.message}")
  image = "/images/kirk.jpg"
  dooutput(res, message, image)

app.get '/spock/:message', (req, res) ->
  message = ops.khan("#{req.params.message}") 
  image = "/images/spock.jpg"
  dooutput(res, message, image)

app.get '/jones/:message', (req, res) ->
  message = ops.jones("#{req.params.message}") 
  image = "/images/jones.jpg"
  dooutput(res, message, image)

###
  Additional routes should go above the catch all /:thing/ route

app.get '/:thing/:from', (req, res) ->
  message = "Fuck #{req.params.thing}."
  image = "- #{req.params.from}"
  dooutput(res, message, image)
###

port = process.env.PORT || 5000
app.listen port
console.log "KHANAAS Started on port #{port}"
