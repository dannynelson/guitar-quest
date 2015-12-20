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
import Navbar from './containers/Navbar'
import PiecesByLevel from './containers/PiecesByLevel'
import Hello from './containers/Hello'
import * as todoActions from './actions'

const store = configureStore()
const history = createHistory()

syncReduxAndRouter(history, store)

console.log({PiecesByLevel, Navbar})

render(
  // ... and to provide our Redux store to our Root component as a prop so that Redux
  // Provider can do its job.
  <Provider store={store}>
    <Router history={history}>
      <Route path="/" component={Navbar}>
        <Route path="pieces_by_level/:level" component={PiecesByLevel}/>
        <Route path="hello" component={Hello}/>
      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
)
