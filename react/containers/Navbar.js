import React, { Component, PropTypes } from 'react'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'
import { pushPath } from 'redux-simple-router'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { connect } from 'react-redux'
import DevTools from '../DevTools'

class AppNavigation extends Component {
  render() {
    return (
      <div>
        <DevTools />
        <Navbar>
          <Navbar.Header>
            <Navbar.Brand>GuitarQuest</Navbar.Brand>
          </Navbar.Header>
          <Nav>
            <NavItem eventKey={1} onClick={() => this.props.pushPath('/pieces_by_level/1')}>Pieces</NavItem>
            <NavItem eventKey={1} onClick={() => this.props.pushPath('/hello')}>Hello</NavItem>
          </Nav>
        </Navbar>
        {this.props.children}
      </div>
    )
  }
}
AppNavigation.propTypes = {}

function mapStateToProps(state) {
  return {
    routing: state.routing,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    todoActions: bindActionCreators(todoActions, dispatch),
    pushPath: bindActionCreators(pushPath, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppNavigation)
