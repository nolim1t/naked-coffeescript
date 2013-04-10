mongo = require './mongo.coffee'
request = require 'request'

handler = (req, res) ->
  if req.body.checkin != undefined
    try
      checkinobj = JSON.parse(req.body.checkin)
      tz = checkinobj.timeZone;
      ts = checkinobj.createdAt;
      id = checkinobj.id;
      user = checkinobj.user;
      venue = checkinobj.venue;
      
      # TODO: Process the checkin or something

      
      res.send('0');
    catch err
      res.send('-2')

  else
    res.send('-1')

module.exports = {
  handler: handler
}
