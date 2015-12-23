import _ from 'lodash'
import React, { Component, PropTypes } from 'react'
import { Row, Col, Grid } from 'react-bootstrap'
import { bindActionCreators } from 'redux'
import { loadLevelPieces } from 'local_modules/actions/pieces'
import PiecesList from './components/PiecesList'
import { connect } from 'react-redux'

class Container extends Component {
  componentDidMount() {
    const { dispatch } = this.props
    dispatch(loadLevelPieces(0))
  }

  render() {
    const { piecesByLevel } = this.props
    const pieces = piecesByLevel[0]
    if (!pieces) return <div></div>;

    return (
      <Grid>
        <PiecesList pieces={pieces} />
      </Grid>
    )
  }
}
Container.propTypes = {}

function mapStateToProps(state) {
  return {
    piecesByLevel: (state.data ? _.groupBy(_.values(state.data.pieces.piecesById), 'level') : {})
  }
}

export default connect(mapStateToProps)(Container)
