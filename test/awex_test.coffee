chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'hubot-awex', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/awex')(@robot)

  it 'registers a respond listener for awex ping', ->
    expect(@robot.respond).to.have.been.calledWith(/awex ping/i)
