// Tutorial 12 - Provider-and-connect.js

// This file is the entry point of our JS bundle. It's here that we'll create our Redux store,
// instantiate our React Application root component and attach it to the DOM.

import React from 'react'
import { Provider } from 'react-redux'

import { render } from 'react-dom'
import { Router, Route, IndexRoute } from 'react-router'
import { createHistory } from 'history'
import { syncReduxAndRouter, routeReducer } from 'redux-simple-router'
import configureStore from './store'
import AppRoute from './routes/App'

const store = configureStore()
const history = createHistory()
syncReduxAndRouter(history, store)
const routeConfig = [
  AppRoute
]

render(
  // ... and to provide our Redux store to our Root component as a prop so that Redux
  // Provider can do its job.
  <Provider store={store}>
    <Router history={history} routes={routeConfig} />
  </Provider>,
  document.getElementById('root')
)
