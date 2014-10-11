chai = require 'chai'
chai.should()
expect = chai.expect
sinon = require 'sinon'
MiyoFilters = require '../variables.js'
fs = require 'fs'

describe 'variables_initialize', ->
	ms = null
	request = null
	id = null
	stash = null
	beforeEach ->
		ms = sinon.stub()
		ms.filters = {}
		request = sinon.stub()
		id = 'OnTest'
	it 'should return original argument', ->
		argument = dummy: 'dummy'
		return_argument = MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		return_argument.should.be.deep.equal argument
	it 'should define variables and methods', ->
		argument = dummy: 'dummy'
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		ms.variables.should.be.instanceof Object
		ms.variables_temporary.should.be.instanceof Object
		ms.variables_save.should.be.instanceof Function
		ms.variables_load.should.be.instanceof Function
	it 'should set miyo_template_stash', ->
		ms.filters.miyo_template_stash = {}
		argument = dummy: 'dummy'
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		ms.variables.dummy = 'dummy'
		ms.variables_temporary.dummy = 'dummy'
		ms.filters.miyo_template_stash.should.have.property 'v'
		ms.filters.miyo_template_stash.v.should.be.instanceof Function
		ms.filters.miyo_template_stash.v.call(ms, request, id).should.be.deep.equal ms.variables
		ms.filters.miyo_template_stash.should.have.property 'vt'
		ms.filters.miyo_template_stash.vt.should.be.instanceof Function
		ms.filters.miyo_template_stash.vt.call(ms, request, id).should.be.deep.equal ms.variables_temporary

describe 'variables_load', ->
	ms = null
	request = null
	id = null
	stash = null
	beforeEach ->
		ms = sinon.stub()
		ms.filters = {}
		request = sinon.stub()
		id = 'OnTest'
	it 'should read', ->
		argument = {}
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		ms.variables_load('test/variables.json')
		ms.variables.should.be.deep.equal {
			var: 23
			nest:
				a: 1
				b: 1
		}
	it 'should called from filter', ->
		argument = variables_load: 'test/variables.json'
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		MiyoFilters.variables_load.call ms, argument, request, id, stash
		ms.variables.should.be.deep.equal {
			var: 23
			nest:
				a: 1
				b: 1
		}

describe 'variables_save', ->
	ms = null
	request = null
	id = null
	stash = null
	writeFileSync = null
	beforeEach ->
		ms = sinon.stub()
		ms.filters = {}
		request = sinon.stub()
		id = 'OnTest'
		writeFileSync = sinon.stub fs, 'writeFileSync'
	afterEach ->
		writeFileSync.restore()
	it 'should write', ->
		argument = {}
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		ms.variables = {
			var: 23
			nest:
				a: 1
				b: 1
		}
		ms.variables_save('test/variables.json')
		writeFileSync.calledOnce.should.be.true
		writeFileSync.firstCall.calledWith 'test/variables.json', JSON.stringify ms.variables, 'utf8'
	it 'should called from filter', ->
		argument = variables_save: 'test/variables.json'
		MiyoFilters.variables_initialize.call ms, argument, request, id, stash
		ms.variables = {
			var: 23
			nest:
				a: 1
				b: 1
		}
		MiyoFilters.variables_save.call ms, argument, request, id, stash
		writeFileSync.calledOnce.should.be.true
		writeFileSync.firstCall.calledWith 'test/variables.json', JSON.stringify ms.variables, 'utf8'
