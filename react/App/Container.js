import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import Navbar from './components/Navbar'
import DevTools from 'local_modules/components/DevTools'

class Container extends Component {
  render() {
    return (
      <div>
        <DevTools />
        <Navbar />
        {this.props.children}
      </div>
    )
  }
}
Container.propTypes = {}

export default Container
