import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import DevTools from 'local_modules/components/DevTools'

class Container extends Component {
  render() {
    return (
      <div>
        <DevTools />
        {this.props.children}
      </div>
    )
  }
}
Container.propTypes = {}

export default connect()(Container)

