import qs from 'qs'
import fetch from 'isomorphic-fetch'
import { normalize, Schema, arrayOf } from 'normalizr'

// {
//    method: ''
//    url: ''
//    qs: {}
//    types: [USER_REQUEST, USER_SUCCESS, USER_FAILURE]
// }
export default function reduxFetch(config) {
  return dispatch => {

    var finalUrl = config.url
    if (config.qs) {
      finalUrl += '?'
      finalUrl += qs.stringify(config.qs)
    }

    const fetchConfig = config.fetchConfig || {}
    const meta =  {
      url: finalUrl,
      config: fetchConfig
    }

    dispatch({
      type: config.types[0],
      meta: meta
    })

    return fetch(finalUrl, fetchConfig)
    .then(response => {
      return response.json()
    }).then((json) => {
      var normalizedResponse = null
      if (config.normalizeSchema) {
        normalizedResponse = normalize(json, config.normalizeSchema)
      } else {
        normalizedResponse = json
      }
      dispatch({
        type: config.types[1],
        payload: normalizedResponse,
        meta: meta
      })
      return json
    }).then(null, err => {
      dispatch({
        type: config.types[2],
        error: true,
        payload: err,
        meta: meta
      })
      throw err
    })
  }
}
