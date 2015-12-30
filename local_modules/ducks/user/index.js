import _ from 'lodash'
import Promise from 'bluebird'
import { createAction, handleAction, handleActions } from 'redux-actions'
import { normalize, Schema, arrayOf } from 'normalizr';
import createFetchAction from 'local_modules/redux_fetch'
import settings from 'local_modules/settings'

const SERVER_URL = settings.server.url
const pieceSchema = new Schema('pieces', {idAttribute: '_id'})
const MODULE_NAME = 'user'

export const initialState = {
  isFetching: false,
  error: null,
  user: {}
}

export const REGISTER_REQUEST = `${MODULE_NAME}/REGISTER_REQUEST`
export const REGISTER_SUCCESS = `${MODULE_NAME}/REGISTER_SUCCESS`
export const REGISTER_FAILURE = `${MODULE_NAME}/REGISTER_FAILURE`
export function register(params) {
  return createFetchAction({
    url: `${SERVER_URL}/users/register`,
    method: 'POST',
    body: params,
    types: [REGISTER_REQUEST, REGISTER_SUCCESS, REGISTER_FAILURE]
  })
}

export const CONFIRM_EMAIL_REQUEST = `${MODULE_NAME}/CONFIRM_EMAIL_REQUEST`
export const CONFIRM_EMAIL_SUCCESS = `${MODULE_NAME}/CONFIRM_EMAIL_SUCCESS`
export const CONFIRM_EMAIL_FAILURE = `${MODULE_NAME}/CONFIRM_EMAIL_FAILURE`
export function confirmEmail({tempUserId}={}) {
  return createFetchAction({
    url: `${SERVER_URL}/users/confirm/${tempUserId}`,
    method: 'POST',
    types: [CONFIRM_EMAIL_REQUEST, CONFIRM_EMAIL_SUCCESS, CONFIRM_EMAIL_FAILURE]
  })
}

export const LOGIN_REQUEST = `${MODULE_NAME}/LOGIN_REQUEST`
export const LOGIN_SUCCESS = `${MODULE_NAME}/LOGIN_SUCCESS`
export const LOGIN_FAILURE = `${MODULE_NAME}/LOGIN_FAILURE`
export function login(params) {
  return createFetchAction({
    url: `${SERVER_URL}/users/login`,
    method: 'POST',
    body: params,
    types: [LOGIN_REQUEST, LOGIN_SUCCESS, LOGIN_FAILURE]
  })
}

export const LOGOUT_REQUEST = `${MODULE_NAME}/LOGOUT_REQUEST`
export const LOGOUT_SUCCESS = `${MODULE_NAME}/LOGOUT_SUCCESS`
export const LOGOUT_FAILURE = `${MODULE_NAME}/LOGOUT_FAILURE`
export function logout() {
  return createFetchAction({
    url: `${SERVER_URL}/users/logout`,
    method: 'POST',
    types: [LOGOUT_REQUEST, LOGOUT_SUCCESS, LOGOUT_FAILURE]
  })
}

export default function userReducer(state=initialState, action) {
  state = Object.assign({}, state, {
    isFetching: false,
    error: null
  })
  switch (action.type) {
    case REGISTER_REQUEST:
    case CONFIRM_EMAIL_REQUEST:
    case LOGIN_REQUEST:
    case LOGOUT_REQUEST:
      return Object.assign({}, state, {
        isFetching: true,
      })
    case CONFIRM_EMAIL_SUCCESS:
      return Object.assign({}, state, {
        user: action.payload,
      })
    default:
      return state
  }
}
