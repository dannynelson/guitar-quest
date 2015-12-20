import React, { Component, PropTypes } from 'react'
import { Router, Route, IndexRoute } from 'react-router'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'

import { connect } from 'react-redux'

class PiecesByLevel extends Component {
  render() {
    return (
      <Route path="/" component={Navbar}>
      </Route>
      <div>Pieces By Level</div>
    )
  }
}
PiecesByLevel.propTypes = {}

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

export default connect(mapStateToProps, mapDispatchToProps)(PiecesByLevel)
