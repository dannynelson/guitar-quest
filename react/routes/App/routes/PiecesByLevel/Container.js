import _ from 'lodash'
import React, { Component, PropTypes } from 'react'
import { createSelector, createStructuredSelector } from 'reselect'
import { Row, Col, Grid } from 'react-bootstrap'
import { bindActionCreators } from 'redux'
import * as pieceActions from 'local_modules/ducks/piece'
import PiecesList from './components/PiecesList'
import PageLoader from 'local_modules/components/PageLoader'
import { connect } from 'react-redux'

class Container extends Component {
  componentDidMount() {
    const { dispatch, params } = this.props
    dispatch(pieceActions.fetchForLevel(+params.level))
  }

  render() {
    const { pieces, isFetching } = this.props
    return (
      <Grid>
        {!pieces && isFetching && <PageLoader />}
        {!!pieces && <PiecesList pieces={pieces} />}
      </Grid>
    )
  }
}
Container.propTypes = {}

var selector = createStructuredSelector({
  isFetching: state => state.piece.isFetching,
  error: state => state.piece.error,
  pieces: createSelector(
    state => state.piece.pieceIdsByLevel,
    (state, props) => +props.params.level,
    state => state.piece.entities.pieces,
    (pieceIdsByLevel, currentLevel, piecesById) => {
      var pieceIds = pieceIdsByLevel[currentLevel] || []
      return pieceIds.map(pieceId => piecesById[pieceId])
    }
  )
})
export default connect(selector)(Container)
