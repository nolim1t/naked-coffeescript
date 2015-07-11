mongo = require './mongo.coffee'
randomstring = require './randomstring.coffee'

module.exports = {
	create: (info, cb) ->
		result = {created: false, meta: {code: -1, msg: 'Not created'}}
		if info.phonenumber != undefined
			mongo.dbhandler (db) ->
				collection = db.collection 'accesstokens'
				record = {}
				record.phonenumber = info.phonenumber
				randomstring.string (s) ->
					record.token = s.string
					record.tokencreated = Math.round(new Date().getTime() / 1000)
					record.profilecreated = false
					collection.save record, (saveerr, saverecord) ->
						if not saveerr
							result.created = true
							result.record = saverecord
							result.meta.code = 0
							result.meta.msg = 'Done'
							cb(result)
						else
							result.meta.code = -2
							result.meta.msg = 'Something bad happened'
							cb(result)
		else
			cb(result)

	validate: (info, cb) ->
		result = {validated: false, meta: {code: -1, msg: 'Specify a token to validate'}}
		if info.token != undefined
			mongo.dbhandler (db) ->
				collection = db.collection 'accesstokens'
				query = {token: info.token}
				collection.findOne query, (terr, tfound) ->
					if not terr
						if tfound == undefined
							result.meta.code = -1
							result.meta.msg = 'Token not found'
							cb(result)
						else
							if info.profileupdate == true
								record = tfound
								record.profilecreated = true
								collection.update query, record, (err, updated) -> updated
								result.meta.code = 0
								result.meta.msg = 'Token Found and updated'
								result.validated = true
								result.updated = true
								cb(result)

							else
								result.meta.code = 0
								result.meta.msg = 'Token Found'
								result.validated = true
								result.profilecreated = tfound.profilecreated
								cb(result)
		else
			cb(result)
}
