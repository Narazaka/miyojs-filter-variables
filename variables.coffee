### (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 ###

unless MiyoFilters?
	MiyoFilters = {}

MiyoFilters.variables_initialize = type: 'through', filter: (argument, request, id) ->
	@variables = {}
	@variables_temporary = {}
	@variables_load = (file) =>
		fs = require 'fs'
		path = require 'path'
		file_path = path.join process.cwd(), file
		try
			json_str = fs.readFileSync file_path, 'utf8'
			@variables = JSON.parse json_str
		catch
			return
	@variables_save = (file) =>
		fs = require 'fs'
		path = require 'path'
		file_path = path.join process.cwd(), file
		json_str = JSON.stringify @variables
		fs.writeFileSync file_path, json_str, 'utf8'
	if @filters.miyo_template_stash?
		@filters.miyo_template_stash.v = (value, request, id) -> @variables
		@filters.miyo_template_stash.vt = (value, request, id) -> @variables_temporary
	argument

MiyoFilters.variables_load = type: 'through', filter: (argument, request, id) ->
	unless argument?.variables_load?
		throw 'argument.variables_load undefined'
	@variables_load argument.variables_load
	argument

MiyoFilters.variables_save = type: 'through', filter: (argument, request, id) ->
	unless argument?.variables_save?
		throw 'argument.variables_save undefined'
	@variables_save argument.variables_save
	argument

if module? and module.exports?
	module.exports = MiyoFilters
