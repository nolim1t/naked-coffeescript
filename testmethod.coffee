localization = require './localization.coffee'

module.exports = (info, cb) ->
	payload = {meta: {code: 200, msg: localization["okapistatus"][info.language], method: info.method}, result: {lang: info.language, path: info.urlpath, body: info.body, query: info.query}}	

	cb(payload)
