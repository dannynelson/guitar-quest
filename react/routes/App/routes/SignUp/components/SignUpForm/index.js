import React, { Component, PropTypes } from 'react'
import { Panel, Input, Button, Alert } from 'react-bootstrap'
import { reduxForm } from 'redux-form'
import styles from './styles.css'

class SignUpForm extends Component {
  render() {
    const {fields: {firstName, lastName, email, password}, error, handleSubmit} = this.props
    debugger
    return (
      <Panel className={styles.panel}>
        <form onSubmit={handleSubmit}>
          <h4 className={styles.title}>Sign up for free</h4>
          {error && <Alert bsStyle="danger">{error}</Alert>}
          <input className="form-control" type="text" placeholder="First Name" {...firstName}/>
          <div className="input-helper-text">first name required</div>
          <input className="form-control" type="text" placeholder="Last Name" {...lastName}/>
          <div className="input-helper-text">last name required</div>
          <input className="form-control" type="email" placeholder="Email" {...email}/>
          <div className="input-helper-text">must be a valid email address</div>
          <input className="form-control" type="password" placeholder="Password" {...password}/>
          <div className="input-helper-text">8 characters minimum</div>
          <Button className={styles.signUpButton} bsStyle="primary" block onClick={handleSubmit}>Sign Up</Button>
        </form>
      </Panel>
    )
  }
}

SignUpForm = reduxForm({
  form: 'signUp',
  fields: ['firstName', 'lastName', 'email', 'password']
})(SignUpForm);

export default SignUpForm
