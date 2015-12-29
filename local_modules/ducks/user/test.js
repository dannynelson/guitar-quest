import 'local_modules/test_helpers/chai_config'
import Promise from 'bluebird'
import nock from 'nock'
import sinon from 'sinon'
import userFactory from 'local_modules/models/user/factory'
import settings from 'local_modules/settings'
import mockStore from 'local_modules/test_helpers/mock_store'
import objectIdString from 'objectid'
import usersReducer from './index'
import * as userActions from './index'

const SERVER_URL = settings.server.url
const userInitialState = userActions.initialState
const initialState = {user: userInitialState}

describe('redux user', () => {
  describe('actions', () => {
    afterEach(() => {
      nock.cleanAll()
    })

    describe('.register()', () => {
      it('handles successful request', (done) => {
        const user = userFactory.create()
        nock(SERVER_URL)
          .post('/users/register', {
            firstName: 'Julian',
            lastName: 'Bream',
            email: 'bream@guitarquest.com',
            password: 'abcd1234!'
          })
          .reply(201, {})

        const meta = {
          url: `${SERVER_URL}/users/register`,
          config: {
            method: 'POST',
            body: JSON.stringify({
              firstName: 'Julian',
              lastName: 'Bream',
              email: 'bream@guitarquest.com',
              password: 'abcd1234!'
            }),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            }
          }
        }

        const expectedActions = [
          {
            type: userActions.REGISTER_REQUEST,
            meta: meta
          },
          {
            type: userActions.REGISTER_SUCCESS,
            payload: {},
            meta: meta
          }
        ]
        const store = mockStore(initialState, expectedActions, done)
        store.dispatch(userActions.register({
          firstName: 'Julian',
          lastName: 'Bream',
          email: 'bream@guitarquest.com',
          password: 'abcd1234!'
        }))
      })
    })
  })

  describe('reducer', () => {
    it('REGISTER_REQUEST', () => {
      const ACTION = {
        type: userActions.REGISTER_REQUEST
      }
      const state = usersReducer(userInitialState, ACTION)
      expect(state).to.deep.equal({
        isFetching: true,
        error: null,
        user: {}
      })
    })
  })
})
