// import {expect} from 'chai'
// import React from 'react'
// import pieceFactory from 'local_modules/models/piece/factory'
// import TestUtils from 'react-addons-test-utils'
// import PiecePanel from './index'
//
var expect = require('chai').expect
var React = require('react')
var pieceFactory = require('local_modules/models/piece/factory')
var TestUtils = require('react-addons-test-utils')
var PiecePanel = require('./index')

function setup(piece) {
  var props = {
    addTodo: expect.createSpy()
  }

  var renderer = TestUtils.createRenderer()
  renderer.render(<Header {...props} />)
  var output = renderer.getRenderOutput()

  return {
    props,
    output,
    renderer
  }
}

describe('PiecePanel', () => {
  it('renders piece', () => {
    var piece = pieceFactory.create()
    var output = setup(piece).output
    console.log(output)

    // expect(output.type).toBe('header')
    // expect(output.props.className).toBe('header')

    // let [ h1, input ] = output.props.children

    // expect(h1.type).toBe('h1')
    // expect(h1.props.children).toBe('todos')

    // expect(input.type).toBe(TodoTextInput)
    // expect(input.props.newTodo).toBe(true)
    // expect(input.props.placeholder).toBe('What needs to be done?')
  })
})
