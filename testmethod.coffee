module.exports = (info, cb) ->
	payload = {meta: {code: 200, msg: 'OK', method: info.method}, result: {lang: info.language, path: info.urlpath, body: info.body, query: info.query}}	

	cb(payload)
