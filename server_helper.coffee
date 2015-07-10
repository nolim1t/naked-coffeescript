foursquarepush = require './lib/4sqpush.coffee'

powered_by = (req, res, next) ->
	res.removeHeader "X-Powered-By"
	res.header "X-Powered-By", "Your mom <3"

	# Means keep processing the request through server.coffee
	next()


# Export out the function. Sharing is caring
module.exports = {
	headermiddleware: powered_by
}
