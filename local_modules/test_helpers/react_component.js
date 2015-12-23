import _ from 'lodash'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'
var $R = require('rquery')(_, React, ReactDOM, TestUtils)
global.React = React

// Render component into the DOM, and return it wrapped in rquery
export function renderComponent(component) {
  var renderedComponent = TestUtils.renderIntoDocument(component)
  return $R(ReactDOM.findDOMNode(renderedComponent))
}
