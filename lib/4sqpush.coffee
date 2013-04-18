mongo = require './mongo.coffee'
request = require 'request'
foursquare = require './foursquare.coffee'

handler = (req, res) ->
  if req.body.checkin != undefined and req.body.secret != undefined
    try
      checkinobj = JSON.parse(req.body.checkin)
      tz = checkinobj.timeZone;
      ts = checkinobj.createdAt;
      id = checkinobj.id;
      user = checkinobj.user;
      venue = checkinobj.venue;
      if req.body.secret == process.env.FOURSQUAREREPUSHSECRET
      	# TODO: handle the checkin or something
      	
      	console.log 'All set!'
      	console.log 'User details: ' + JSON.stringify(user)      	
      	console.log 'Venue details: ' + JSON.stringify(venue)
      	console.log 'Timezone details: ' + tz
      	      	
      	res.send('0', 200);
      else
      	console.log 'Error: Invalid push secret'
      	res.send('-1', 401);
    catch err
      console.log 'Error: Something bad happened ' + err
      res.send('-2', 500)

  else
    console.log 'Error: Wrong parameters'
    res.send('-1', 400)

handlertest = (req, res) ->
	res.send('BLAH')
	
module.exports = {
  handler: handler,
  handlertest: handlertest
}
