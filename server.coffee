#!/usr/bin/env coffee

####################################
# Coffeescript-naked (Barry Teoh / @nolim1t on github/twitter)
####################################
# DESCRIPTION
# This is a boilerplate coffeescript server to save time creating backends because
# sometimes parse or stackmob just does not cut it!
# 
# Or you want to create some processing logic before the mobile client is served.
# 
####################################

# Lets set up the port (on heroku or foreman it looks for an environment variable because these web servers are abstracted out)
port = process.env.PORT || 3000

# Need express and express-validator (you should always sanitize any inputs)
express = require 'express'
expressValidator = require 'express-validator'
expresshelper = require './server_helper.coffee'
# awesomesauce http framework
request = require 'request' 
# Generating guids
uuid = require 'node-uuid'

# Lets start the show
app = express.createServer()

app.configure ->	
	app.use express.logger()
	app.use express.bodyParser()
	app.use express.cookieParser()
	# Load the middleware (server_helper.coffee)
	# Pro-tip: You can build out a fully dynamic API from this
	app.use expresshelper.headermiddleware
	app.use expressValidator
	app.use app.router
	app.set 'view engine', 'jade'
	app.set 'views', './views'
	# Directory called static
	app.use express.static(__dirname + '/static')
	app.use express.session({ secret: "shh dont tell. but seriously, please change this" })

##########
# If you got any other URL handlers you can put it here.
# Just to get you started, I've put in a default
##########
app.get '/', (req, res) ->
	error_code = 200
	res.render('default', {title: "nothing to see here"})


# foursquare callback
app.get '/your-4sq-callback-here', (req, res) ->
	if req.query != undefined
		if req.query['code'] != undefined
			foursquare.auth.accesstoken req.query['code'], (cb) ->
				if cb.status == 'ok'
					mongo.dbhandler (db) ->
						collection = db.collection 'users'
						query = {foursquareid: cb.id}
						collection.findOne query, (qerr, qfound) ->
							if not qerr
								if qfound == undefined
									# No record! Create lets make one
									record = {}
									record.foursquareid = cb.id
									record.accesstoken = cb.access_token
									record.profile = cb.profile.contact
									collection.save record, (saveerr, saverecord) ->
										if not saveerr
											res.render('allset', {title: "You're all set!", alreadyConnected: false})
										else
											res.send('Something broke', 500)
								else
									collection.update query, {accesstoken: cb.access_token, foursquareid: cb.id, profile: cb.profile.contact}, (errupdate, updatedprofile) -> console.log updatedprofile
									res.render('allset', {title: "You're all set!", alreadyConnected: true})
				else
					res.send('Something broke', 500)
		else
			res.send('Incorrect parameters', 400)
	else
		res.send('Invalid', 400)

# General 404 Not Found
app.get '*', (req, res) ->
	error_code = 404
	res.send('Not found', error_code)
########
# Fin
console.log 'Started server on port ' + port
app.listen port

