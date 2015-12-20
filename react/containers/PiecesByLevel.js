import React, { Component, PropTypes } from 'react'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'

import { connect } from 'react-redux'

class PiecesByLevel extends Component {
  render() {
    return (
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
