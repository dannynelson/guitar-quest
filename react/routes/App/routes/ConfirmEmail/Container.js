import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col, Grid } from 'react-bootstrap'
import { pushPath } from 'redux-simple-router'
import ConfirmEmailPanel from './components/ConfirmEmailPanel'
import PageLoader from 'local_modules/components/PageLoader'
import * as userActions from 'local_modules/ducks/user'
import styles from './styles.css'

class Container extends Component {
  componentDidMount() {
    const { dispatch } = this.props
    const { query } = this.props.location
    if (query.id) {
      dispatch(userActions.confirmEmail({tempUserId: query.id}))
      .then(() => {
        dispatch(pushPath('/pieces_by_level/0'))
      })
    }
  }

  render() {
    const { query } = this.props.location
    return (
      <Grid>
        {query.id && <PageLoader />}
        {!query.id && <Col md={6} mdOffset={3} className={styles.panel}>
          <ConfirmEmailPanel />
        </Col>}
      </Grid>
    )
  }
}

export default connect()(Container)

