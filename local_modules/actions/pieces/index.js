import superagent from 'superagent-bluebird-promise'
import { CALL_API } from 'redux-api-middleware'

export const PIECES_REQUEST = 'PIECES_REQUEST'
export const PIECES_SUCCESS = 'PIECES_SUCCESS'
export const PIECES_FAILURE = 'PIECES_FAILURE'
export function loadLevelPieces(level) {
  return {
    [CALL_API]: {
      endpoint: `http://127.0.0.1:8075/pieces?level=${level}`,
      method: 'GET',
      types: [
        PIECES_REQUEST,
        PIECES_SUCCESS,
        PIECES_FAILURE
      ]
    }
  }
}
