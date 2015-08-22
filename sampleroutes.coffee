localization = require './localization.coffee'
accessmanager = require './lib/accessmanager.coffee'

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
	
	# Middleware to grab token
	router.use (req, res, next) ->
		if req.headers.token != undefined
			accessmanager.validate {token: req.headers.token}, (cb) ->
				req.accessInfo = cb
				next()
		else
			next()
	
	endpoint_list = [
		{
			endpoint: 'test',
			authrequired: 'no',
			accountneeded: 'no',
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
		res.header 'Cache-Control', 'no-transform,public,max-age=300,s-maxage=900'
		res.status(payload.meta.code).send(JSON.stringify(payload))

	# Default Catchall
	router.all '*', (req, res, next) ->
		payload = {meta: {code: 404, msg: localization["methodnotfound"][req.language]}, result: {lang: req.language, method: req.method, path: req.originalUrl}}
		discovered_endpoint = {}
		discovered_action = {}
		for endpoint in endpoint_list
			if req.originalUrl.indexOf(endpoint.endpoint) != -1
				discovered_endpoint = endpoint


		if discovered_endpoint.strict == true
			endpoint_name = req.originalUrl.replace('/1/','').split('?')[0]
			if discovered_endpoint.endpoint != endpoint_name
				discovered_endpoint = {}

		# Did we find an endpoint? Good lets find a valid action
		if discovered_endpoint.actions != undefined
			for action in discovered_endpoint.actions
				if action.method == req.method
					discovered_action = action

			if discovered_action.includefile != undefined
				info = {accessInfo: req.accessInfo, language: req.language, method: req.method, urlpath: req.originalUrl, body: req.body, query: req.query}
				if discovered_endpoint.authrequired == 'yes'
					if req.accessInfo != undefined
						if req.accessInfo.validated == true
							if discovered_endpoint.accountneeded == 'no'
								require(discovered_action.includefile) info, (cb) ->
									# BEGIN: CACHE Control
									if cb.meta.cachecontrol != undefined
										if cb.meta.cachecontrol.caching != undefined
											cachestring = ''
											if cb.meta.cachecontrol.caching == 'on'
												cachestring = 'no-transform,public'
												if cb.meta.cachecontrol.maxage != undefined
													cachestring = cachestring + ',max-age=' + cb.meta.cachecontrol.maxage.toString()
												else
													cachestring = cachestring + ',max-age=300'
												if cb.meta.cachecontrol.smaxage != undefined
													cachestring = cachestring + ',' + 's-maxage=' + cb.meta.cachecontrol.smaxage.toString()
												else
													cachestring = cachestring + ',s-maxage=900'
											else
												cachestring = 'max-age=0, private, no-cache, no-store'
											# Show the header based on settings
											res.header 'Cache-Control', cachestring
									else
										# By default, dont cache APIs
										res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
									# END: CACHE Control
									res.status(cb.meta.code).send(JSON.stringify(cb))
							else
								if req.accessInfo.profilecreated == true
									require(discovered_action.includefile) info, (cb) ->
										# BEGIN: CACHE Control
										if cb.meta.cachecontrol != undefined
											if cb.meta.cachecontrol.caching != undefined
												cachestring = ''
												if cb.meta.cachecontrol.caching == 'on'
													cachestring = 'no-transform,public'
													if cb.meta.cachecontrol.maxage != undefined
														cachestring = cachestring + ',max-age=' + cb.meta.cachecontrol.maxage.toString()
													else
														cachestring = cachestring + ',max-age=300'
													if cb.meta.cachecontrol.smaxage != undefined
														cachestring = cachestring + ',' + 's-maxage=' + cb.meta.cachecontrol.smaxage.toString()
													else
														cachestring = cachestring + ',s-maxage=900'
												else
													cachestring = 'max-age=0, private, no-cache, no-store'
												# Show the header based on settings
												res.header 'Cache-Control', cachestring
										else
											# By default, dont cache APIs
											res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
										# END: CACHE Control
										res.status(cb.meta.code).send(JSON.stringify(cb))
								else
									payload.meta.code = 401
									payload.meta.msg = localization["errneedfullacct"][req.language]
									res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
									res.status(payload.meta.code).send(JSON.stringify(payload))
						else
							payload.meta.code = 401
							payload.meta.msg = localization["unauthorized"][req.language]
							res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
							res.status(payload.meta.code).send(JSON.stringify(payload))
					else
						payload.meta.code = 401
						payload.meta.msg = localization["unauthorized"][req.language]
						res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
						res.status(payload.meta.code).send(JSON.stringify(payload))
				else
					require(discovered_action.includefile) info, (cb) ->
						# BEGIN: CACHE Control
						if cb.meta.cachecontrol != undefined
							if cb.meta.cachecontrol.caching != undefined
								cachestring = ''
								if cb.meta.cachecontrol.caching == 'on'
									cachestring = 'no-transform,public'
									if cb.meta.cachecontrol.maxage != undefined
										cachestring = cachestring + ',max-age=' + cb.meta.cachecontrol.maxage.toString()
									else
										cachestring = cachestring + ',max-age=300'
									if cb.meta.cachecontrol.smaxage != undefined
										cachestring = cachestring + ',' + 's-maxage=' + cb.meta.cachecontrol.smaxage.toString()
									else
										cachestring = cachestring + ',s-maxage=900'
								else
									cachestring = 'max-age=0, private, no-cache, no-store'
								# Show the header based on settings
								res.header 'Cache-Control', cachestring
						else
							# By default, dont cache APIs
							res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
						# END: CACHE Control
						res.status(cb.meta.code).send(JSON.stringify(cb))
			else
				res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
				res.status(payload.meta.code).send(JSON.stringify(payload))
		else
			res.header 'Cache-Control', 'max-age=0, private, no-cache, no-store'
			res.status(payload.meta.code).send(JSON.stringify(payload))

