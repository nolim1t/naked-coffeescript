localization = require './localization.coffee'

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

	
	endpoint_list = [
		{
			endpoint: 'test',
			authrequired: 'no',
			visibility: 'public',
			actions: [
				{
					method: 'GET',
					includefile: './testmethod.coffee'
				},
				{
					method: 'POST',
					includefile: './testmethod.coffee'
				},
				{
					method: 'PUT',
					includefile: './testmethod.coffee'
				},
				{
					method: 'DELETE',
					includefile: './testmethod.coffee'
				}
			]
		}
	]

	for endpoint in endpoint_list
		for action in endpoint.actions
			switch action.method
				when 'GET' 
					router.get '/' + endpoint.endpoint, (req, res, next) ->
						info = {language: req.language, method: req.method, urlpath: req.originalUrl, query: req.query}
						require(action.includefile) info, (cb) -> 
							res.status(cb.meta.code).send(JSON.stringify(cb))
				when 'POST'
					router.post '/' + endpoint.endpoint, (req, res, next) ->
						info = {language: req.language, method: req.method, urlpath: req.originalUrl, body: req.body, query: req.query}
						require(action.includefile) info, (cb) -> 
							res.status(cb.meta.code).send(JSON.stringify(cb))
				when 'DELETE'
					router.delete '/' + endpoint.endpoint, (req, res, next) ->
						info = {language: req.language, method: req.method, urlpath: req.originalUrl, query: req.query}
						require(action.includefile) info, (cb) -> 
							res.status(cb.meta.code).send(JSON.stringify(cb))
				when 'PUT'
					router.put '/' + endpoint.endpoint, (req, res, next) ->
						info = {language: req.language, method: req.method, urlpath: req.originalUrl, body: req.body, query: req.query}
						require(action.includefile) info, (cb) -> 
							res.status(cb.meta.code).send(JSON.stringify(cb))

	# Index 
	router.get '/', (req, res, next) ->
		methodlist = []
		for def in endpoint_list
			if def.visibility == 'public'
				actionlist = []
				for action in def.actions
					actionlist.push {method: action}
				methodlist.push {endpoint: def.endpoint, protected: def.authrequired, actions: def.actionlist}
		
		payload = {meta: {code: 200, msg: localization["okapistatus"][req.language]}, result: {lang: req.language, endpoints: methodlist}}
		res.status(payload.meta.code).send(JSON.stringify(payload))
	# Default Catchall
	router.all '*', (req, res, next) ->
		payload = {meta: {code: 404, msg: localization["methodnotfound"][req.language]}, result: {lang: req.language, method: req.method, path: req.originalUrl}}
		res.status(payload.meta.code).send(JSON.stringify(payload))

