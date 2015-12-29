import _ from 'lodash'
import React, { Component, PropTypes } from 'react'
import { Row, Col, Grid } from 'react-bootstrap'
import { connect } from 'react-redux'
import * as userActions from 'local_modules/ducks/user'
import SignUpForm from  './components/SignUpForm'

class Container extends Component {
  handleSubmit(formData) {
    const { dispatch } = this.props
    return dispatch(userActions.register(formData))
    .catch(err => {
      throw({_error: err.message})
    })
  }

  render() {
    return (
      <Grid>
        <SignUpForm onSubmit={this.handleSubmit.bind(this)}/>
      </Grid>
    )
  }
}

export default connect()(Container)
