powered_by = (req, res, next) ->
	res.removeHeader "X-Powered-By"
	res.header "X-Powered-By", "Your mom <3"
	api_endpoint = ''

	# If anything in the /api folder then lets insert some headers
	if req.originalUrl.indexOf('/api') != -1
		res.header 'Content-type', 'application/json'
		res.header 'Access-Control-Allow-Origin', '*'
		res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
		res.header 'Access-Control-Allow-Headers', 'Content-Type,Accept,Cookie'

		# Keep processing the request for now
		next()
	else
		# Means keep processing the request through server.coffee
		next()


# Export out the function. Sharing is caring
module.exports = {
	headermiddleware: powered_by
}
