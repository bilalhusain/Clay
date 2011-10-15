express = require 'express'
mongoose = require 'mongoose'

# mongo database definitions
db = {}
DB_CON_URL = 'mongodb://localhost/db'

objectSchema = new mongoose.Schema
	#_id: Object
	name: String

mongoose.model '__clay_object', objectSchema, 'clay_objects'
db.object = mongoose.model '__clay_object'

mongoose.connect DB_CON_URL


# express web application
PORT = 3003
app = express.createServer()

app.configure () ->
	app.use express.bodyParser()

app.post '/objects', (req, res) ->
	obj = new db.object()
	obj.name = req.body.name

	obj.save (err) ->
		if err
			res.send 'could not create'
			return
		res.send 'fine'

app.get '/objects/:id', (req, res) ->
	db.object.findOne {_id: req.params.id}, (err, obj) ->
		if err or not obj
			res.send 'nothing here'
			return
		res.send 'i have it, but won\'t tell you'

app.delete '/objects/:id', (req, res) ->
	db.object.remove {_id: req.params.id}, (err) ->
		if err
			res.send 'could not delete'
			return
		res.send 'deleted'

app.listen PORT

