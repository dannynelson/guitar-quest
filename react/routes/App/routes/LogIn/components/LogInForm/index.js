import React, { Component, PropTypes } from 'react'
import { Panel, Input, Button, Alert } from 'react-bootstrap'
import { reduxForm } from 'redux-form'
import styles from './styles.css'

const validate = values => {
  const errors = {}
  if (!values.email || values.email.length < 1) {
    errors.email = 'email required'
  }
  if (!values.password || values.password.length < 1) {
    errors.password = 'password required'
  }
  return errors
}

class LogInForm extends Component {
  render() {
    const {fields: {email, password}, error, handleSubmit, submitting} = this.props
    return (
      <Panel className={styles.panel}>
        <form onSubmit={handleSubmit}>
          <h4 className={styles.title}>Log in to your account</h4>
          {error && <Alert bsStyle="danger">{error}</Alert>}
          <Input
            type="email"
            help="must be a valid email address"
            placeholder="Email"
            bsStyle={email.touched && email.error && "error"}
            help={email.touched && email.error}
            {...email}/>
          <Input
            type="password"
            placeholder="Password"
            bsStyle={password.touched && password.error && "error"}
            help={password.touched && password.error}
            {...password}/>
          <Button
            type="submit"
            className={styles.signUpButton}
            disabled={submitting}
            bsStyle="primary"
            block>
            Log In
          </Button>
        </form>
      </Panel>
    )
  }
}

LogInForm = reduxForm({
  form: 'signUp',
  fields: ['email', 'password'],
  validate
})(LogInForm);

export default LogInForm
