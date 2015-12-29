import qs from 'qs'
import fetch from 'isomorphic-fetch'
import { normalize, Schema, arrayOf } from 'normalizr'

// {
//    method: ''
//    url: ''
//    qs: {}
//    body: {}
//    types: [USER_REQUEST, USER_SUCCESS, USER_FAILURE]
// }
export default function reduxFetch(config) {
  return dispatch => {
    const url = (() => {
      let result = config.url
      if (config.qs) {
        result += '?'
        result += qs.stringify(config.qs)
      }
      return result
    })()

    const fetchConfig = (() => {
      let result = {}
      if (config.method) result.method = config.method
      if (config.body) result.body = JSON.stringify(config.body)
      if (config.method && config.method !== 'GET') {
        result.headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      }
      return result
    })()

    const meta =  {
      url: url,
      config: fetchConfig
    }

    dispatch({
      type: config.types[0],
      meta: meta
    })

    return fetch(url, fetchConfig)
    .then(response => {
      if (response.status >= 400) {
        return response.text().then(errText => {
          throw new Error(errText)
        })
      } else {
        return response.json()
      }
    }).then((data) => {
      dispatch({
        type: config.types[1],
        payload: data,
        meta: meta
      })
      return data
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
