import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Navbar from './components/Navbar'
import styles from './style.css'
import { pushPath } from 'redux-simple-router'

class Container extends Component {
  render() {
    return (
      <div className={styles.container}>
        <Navbar onNavItemClick={(route) => this.props.dispatch(pushPath(route))}/>
        {this.props.children}
      </div>
    )
  }
}
Container.propTypes = {}

export default connect()(Container)

