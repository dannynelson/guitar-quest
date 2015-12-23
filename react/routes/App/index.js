import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import Container from './Container'
import PiecesByLevelRoute from './routes/PiecesByLevel'

const route = {
  path: '/',
  component: Container,
  childRoutes: [
    PiecesByLevelRoute
  ]
}

export default route
