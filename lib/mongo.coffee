dbhost = process.env.MONGOHOST || "localhost"
dbport = process.env.MONGOPORT || 27017
dbuser = process.env.MONGOUSER || undefined
dbpass = process.env.MONGOPASS || undefined
dbcontainer = process.env.MONGOCONTAINER || "dev"

mongo = require 'mongodb-wrapper'

exports.dbhandler = (callback) ->
	console.log "Host=" + dbhost + "; port=" + dbport
	callback(mongo.db(dbhost, parseInt(dbport), dbcontainer, '', dbuser, dbpass))

exports.ObjectID = mongo.ObjectID
