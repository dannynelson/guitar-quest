import React, { Component, PropTypes } from 'react'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'
import { Link } from 'react-router'


import { connect } from 'react-redux'

class Navbar extends Component {
  render() {
    return (
      <div>
        <div>Navbar</div>
        <ul>
          <li><Link to="/pieces_by_level/1">Pieces</Link></li>
          <li><Link to="/hello">Hello</Link></li>
        </ul>
        {this.props.children}
      </div>
    )
  }
}
Navbar.propTypes = {}

function mapStateToProps(state) {
  return {
    routing: state.routing,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    todoActions: bindActionCreators(todoActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Navbar)
