import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { pushPath } from 'redux-simple-router'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { connect } from 'react-redux'

class AppNavigation extends Component {
  render() {
    return (
      <Navbar toggleButton>
        <Navbar.Header>
          <Navbar.Brand>GuitarQuest</Navbar.Brand>
        </Navbar.Header>
        <Nav>
          <NavItem eventKey={1} onClick={() => this.props.pushPath('/pieces_by_level/1')}>Pieces</NavItem>
          <NavItem eventKey={1} onClick={() => this.props.pushPath('/hello')}>Hello</NavItem>
        </Nav>
      </Navbar>
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
    pushPath: bindActionCreators(pushPath, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppNavigation)
