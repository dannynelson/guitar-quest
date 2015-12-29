import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import Container from './Container'
import PiecesByLevelRoute from './routes/PiecesByLevel'
import SignUpRoute from './routes/SignUp'

const route = {
  path: '/',
  component: Container,
  childRoutes: [
    PiecesByLevelRoute,
    SignUpRoute
  ]
}

export default route
