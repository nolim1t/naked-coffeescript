foursquarepush = require './lib/4sqpush.coffee'

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

		endpoint = req.originalUrl.replace('/api/','').split('?')[0]

		# TO ADD: Process endpoints library
		# EXAMPLE: foursquare push
		if endpoint == "your-4sqpush-endpoint"
			foursquarepush.handler req, res
		error_code = 404
		payload = {meta: error_code, data: [], info: {method: req.method, endpoint: req.originalUrl.replace('/api/','').split('?')[0], queryparams: req.query, bodyparams: req.body}, error: [{message: "Invalid endpoint or method", type: "404NotFound"}]}		
		res.send(JSON.stringify(payload), error_code)
	else
		# Means keep processing the request through server.coffee
		next()


# Export out the function. Sharing is caring
module.exports = {
	headermiddleware: powered_by
}
