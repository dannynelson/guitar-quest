import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col, Grid } from 'react-bootstrap'
import { pushPath } from 'redux-simple-router'
import ConfirmEmailPanel from './components/ConfirmEmailPanel'
import styles from './styles.css'

class Container extends Component {
  render() {
    return (
      <Grid>
        <Col md={6} mdOffset={3} className={styles.panel}>
          <ConfirmEmailPanel />
        </Col>
      </Grid>
    )
  }
}

export default connect()(Container)

