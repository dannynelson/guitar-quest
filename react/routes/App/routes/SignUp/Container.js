import React, { Component, PropTypes } from 'react'
import { pushPath } from 'redux-simple-router'
import { Row, Col, Grid } from 'react-bootstrap'
import { connect } from 'react-redux'
import * as userActions from 'local_modules/ducks/user'
import SignUpForm from  './components/SignUpForm'

class Container extends Component {
  handleSubmit(formData) {
    const { dispatch } = this.props
    return dispatch(userActions.register(formData))
    .then(() => {
      return dispatch(pushPath('/confirm_email'))
    })
    .catch(err => {
      throw({_error: err.message})
    })
  }

  render() {
    return (
      <Grid>
        <Col sm={6} smOffset={3} lg={4} lgOffset={4}>
          <SignUpForm onSubmit={this.handleSubmit.bind(this)}/>
        </Col>
      </Grid>
    )
  }
}

export default connect()(Container)
