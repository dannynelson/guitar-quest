import React, { Component, PropTypes } from 'react'
import { Panel } from 'react-bootstrap'

class ConfirmEmailPanel extends Component {
  render() {
    return (
      <Panel>
        <h5>Confirm Your Email Address</h5>
        <p>Thanks for signing up for GuitarQuest! We just sent a confirmation email to your registration email address. Click on the confirmation link in that email to complete your sign up.</p>
      </Panel>
    )
  }
}

export default ConfirmEmailPanel
