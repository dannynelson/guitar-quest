import React, { Component, PropTypes } from 'react'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'

import { connect } from 'react-redux'

class Hello extends Component {
  render() {
    return (
      <div>Hello world</div>
    )
  }
}

export default Hello
