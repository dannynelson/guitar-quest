import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import Container from './Container'

const route = {
  path: 'log_in',
  bypassAuth: true,
  component: Container
}

export default route
