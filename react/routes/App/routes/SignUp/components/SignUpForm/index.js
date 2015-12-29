import React, { Component, PropTypes } from 'react'
import { Panel, Input, Button, Alert } from 'react-bootstrap'
import { reduxForm } from 'redux-form'
import styles from './styles.css'

const validate = values => {
  const errors = {}
  if (!values.firstName) {
    errors.firstName = 'first name required'
  }
  if (!values.lastName) {
    errors.lastName = 'last name required'
  }
  if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(values.email)) {
    errors.email = 'must be a valid email address'
  }
  if (!values.password || values.password.length < 8) {
    errors.password = '8 characters minimum'
  }
  return errors
}

class SignUpForm extends Component {
  render() {
    const {fields: {firstName, lastName, email, password}, error, handleSubmit, submitting} = this.props
    return (
      <Panel className={styles.panel}>
        <form onSubmit={handleSubmit}>
          <h4 className={styles.title}>Sign up for free</h4>
          {error && <Alert bsStyle="danger">{error}</Alert>}
          <Input
            type="text"
            bsStyle={firstName.touched && firstName.error && "error"}
            help={firstName.touched && firstName.error}
            placeholder="First Name"
            {...firstName} />
          <Input
            type="text"
            help="last name required"
            placeholder="Last Name"
            bsStyle={lastName.touched && lastName.error && "error"}
            help={lastName.touched && lastName.error}
            {...lastName}/>
          <Input
            type="email"
            help="must be a valid email address"
            placeholder="Email"
            bsStyle={email.touched && email.error && "error"}
            help={email.touched && email.error}
            {...email}/>
          <Input
            type="password"
            help="8 characters minimum"
            placeholder="Password"
            bsStyle={password.touched && password.error && "error"}
            {...password}/>
          <Button
            className={styles.signUpButton}
            disabled={submitting}
            bsStyle="primary"
            block
            onClick={handleSubmit}>
            Sign Up
          </Button>
        </form>
      </Panel>
    )
  }
}

SignUpForm = reduxForm({
  form: 'signUp',
  fields: ['firstName', 'lastName', 'email', 'password'],
  validate
})(SignUpForm);

export default SignUpForm
