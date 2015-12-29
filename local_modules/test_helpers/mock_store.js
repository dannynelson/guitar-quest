// import { createStore, applyMiddleware, compose } from 'redux'
// import thunk from 'redux-thunk'
// var rootReducer = () => {}

// export default function configureStore() {
//   const finalCreateStore = compose(
//     applyMiddleware(thunk)
//   )(createStore);
//   return finalCreateStore(rootReducer)
// }
import configureMockStore from 'redux-mock-store'
import thunk from 'redux-thunk'

var mockStore = configureMockStore([thunk])
export default mockStore
