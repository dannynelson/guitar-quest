import _ from 'lodash'
import { pushPath } from 'redux-simple-router'
import * as userActions from 'local_modules/ducks/user'
import store from './store'

export default function handleOnEnter(nextState, transition, callback) {
  const BYPASS_AUTH = _.any(nextState.routes, (route) => route.bypassAuth)
  if (!BYPASS_AUTH) {
    store.dispatch(userActions.assertLoggedIn()).then(() => {
      callback()
    }).catch(err => {
      store.dispatch(pushPath('/log_in'))
    })
  } else {
    callback()
  }

}
