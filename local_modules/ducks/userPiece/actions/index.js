import _ from 'lodash'
import url from 'url'
import fetch from 'isomorphic-fetch'
import { normalize, Schema, arrayOf } from 'normalizr';
import { pieceSchema, userPieceSchema } from 'local_modules/entities/schemas'
import { createAction, handleAction, handleActions } from 'redux-actions'
import types from '../types'
import {pieceSchema, userPieceSchema} from '../normalizeSchemas'
import reduxFetch from 'local_modules/redux_fetch'
import { normalize, Schema, arrayOf } from 'normalizr'

export function fetchForLevel(level) {
  dispatch => {
    dispatch(createAction(types.LEVEL_REQUEST)())
    return dispatch(fetchLevelPieces(level))
    .then((pieces) => {
      pieceIds = pieces.map(piece => piece._id)
      return dispatch(fetchUserPieces(pieceIds))
    }).then(() => {
      dispatch(createAction(RECEIVE_LEVEL)())
    }).catch(err => {
      dispatch(createAction(RECEIVE_LEVEL)())
    })
  }
}

export function fetchForPieceId(pieceId) {
  return reduxFetch({
    method: 'GET'
    url: `http://127.0.0.1:8075/pieces/${pieceId}`
    types: [types.PIECE_REQUEST, types.PIECE_SUCCESS]
  })
}

export function fetchForPieceAndUser(options={}) {
  const {pieceId, userId} = options
  dispatch => {
    return dispatch(fetchLevelPieces).then((pieces) => {
      pieceIds = pieces.map(piece => piece._id)
      return fetchUserPieces(pieceIds)
    })
  }
}

function fetchUserPiece(userPieceId) {
  return reduxFetch({
    method: 'GET',
    url: `http://127.0.0.1:8075/user_pieces/${userPieceId}`,
    qs: {level},
    types: [types.PIECE_REQUEST, types.PIECE_SUCCESS, types.PIECE_FAILURE]
    normalizeSchema: userPiece
  })
}

function fetchPiece(pieceId) {
  return reduxFetch({
    method: 'GET',
    url: `http://127.0.0.1:8075/pieces/${pieceId}`,
    types: [types.PIECE_REQUEST, types.PIECE_SUCCESS, types.PIECE_FAILURE]
    normalizeSchema: pieceSchema
  })
}

function fetchUserPieceWithHistory({pieceId, userId}) {
  return reduxFetch({
    method: 'GET',
    url: `http://127.0.0.1:8075/pieces/${pieceId}`,
    qs: {
      pieceId: $stateParams.pieceId,
      userId: user._id,
      $add: ['historyChanges']
    },
    normalizeSchema: userPieceSchema
    types: [types.USERPIECE_REQUEST, types.USERPIECE_SUCCESS, types.USERPIECE_FAILURE]
  })
}

function fetchLevelPieces(level) {
  return reduxFetch({
    method: 'GET',
    url: `http://127.0.0.1:8075/pieces`,
    qs: {level},
    normalizeSchema: arrayOf(pieceSchema),
    types: [types.PIECE_REQUEST, types.PIECE_SUCCESS, types.PIECE_FAILURE]
  })
}

function fetchUserPieces(pieceIds) {
  return reduxFetch({
    method: 'GET',
    url: `http://127.0.0.1:8075/user_pieces`,
    qs: {pieceId: pieceIds},
    normalizeSchema: arrayOf(userPieceSchema),
    types: [types.USERPIECE_REQUEST, types.USERPIECE_SUCCESS, types.USERPIECE_FAILURE]
  })
}
