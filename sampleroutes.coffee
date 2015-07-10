module.exports = (router) ->
	router.use (req, res, next) ->
		# Router Middleware
		res.header 'Content-type', 'application/json'
		res.header 'Access-Control-Allow-Origin', '*'
		res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
		res.header 'Access-Control-Allow-Headers', 'Content-Type,Accept,Cookie'		

		# Language check (http://www.ietf.org/rfc/rfc1766.txt)
		if req.acceptsLanguages('en', 'en-US', 'en-GB')
			req.language = 'en'
		else if req.acceptsLanguages('zh')
			req.language = 'zh'
		else if req.acceptsLanguages('ko')
			req.language = 'ko'
		else if req.acceptsLanguages('ja')
			req.language = 'ja'
		else
			req.language = 'en'

		next()

	
	endpoint_list = ['test']

	for endpoint in endpoint_list
		router.get '/' + endpoint, (req, res, next) ->		
			payload = {meta: {code: 200, msg: 'OK', method: 'GET'}, result: {lang: req.language}}
			res.status(payload.meta.code).send(JSON.stringify(payload))

		router.delete '/' + endpoint, (req, res, next) ->		
			payload = {meta: {code: 200, msg: 'OK', method: 'DELETE'}, result: {lang: req.language}}
			res.status(payload.meta.code).send(JSON.stringify(payload))

		router.post '/' + endpoint, (req, res, next) ->		
			payload = {meta: {code: 200, msg: 'OK', method: 'POST'}, result: {lang: req.language}}
			res.status(payload.meta.code).send(JSON.stringify(payload))

		router.put '/' + endpoint, (req, res, next) ->		
			payload = {meta: {code: 200, msg: 'OK', method: 'PUT'}, result: {lang: req.language}}
			res.status(payload.meta.code).send(JSON.stringify(payload))

	router.all '*', (req, res, next) ->
		payload = {meta: {code: 404, msg: 'Method or operation not found'}, result: {lang: req.language}}
		res.status(payload.meta.code).send(JSON.stringify(payload))
