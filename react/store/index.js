import { createStore } from 'redux'
import rootReducer from '../reducers/index.js'

export default function configureStore(initialState) {
  var store = createStore(rootReducer, initialState)

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept('../reducers', () => {
      const nextReducer = require('../reducers')
      store.replaceReducer(nextReducer)
    })
  }

  return store
}
