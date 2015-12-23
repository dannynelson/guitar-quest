import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { connect } from 'react-redux'

class AppNavigation extends Component {
  render() {
    return (
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>GuitarQuest</Navbar.Brand>
        </Navbar.Header>
        <Nav>
          <NavItem className="pieces" eventKey={1} onClick={this.props.onNavItemClick.bind(null, '/pieces_by_level/1')}>Pieces</NavItem>
          <NavItem className="hello" eventKey={1} onClick={this.props.onNavItemClick.bind(null, '/hello')}>Hello</NavItem>
        </Nav>
      </Navbar>
    )
  }
}
AppNavigation.propTypes = {
  onNavItemClick: PropTypes.func.isRequired
}

export default AppNavigation
