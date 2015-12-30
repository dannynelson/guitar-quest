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
          <Navbar.Toggle />
        </Navbar.Header>
        <Navbar.Collapse>
          <Nav>
            <NavItem className="pieces" eventKey={1} onClick={this.props.onNavItemClick.bind(null, '/pieces_by_level/1')}>Pieces</NavItem>
            <NavItem className="confirm email" eventKey={1} onClick={this.props.onNavItemClick.bind(null, '/confirm_email')}>Hello</NavItem>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    )
  }
}
AppNavigation.propTypes = {
  onNavItemClick: PropTypes.func.isRequired
}

export default AppNavigation
