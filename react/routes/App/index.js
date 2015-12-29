import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import Container from './Container'
import PiecesByLevelRoute from './routes/PiecesByLevel'
import SignUpRoute from './routes/SignUp'
import ConfirmEmailRoute from './routes/ConfirmEmail'

const route = {
  path: '/',
  component: Container,
  childRoutes: [
    PiecesByLevelRoute,
    SignUpRoute,
    ConfirmEmailRoute
  ]
}

export default route
