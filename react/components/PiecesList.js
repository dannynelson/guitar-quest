import React, { Component, PropTypes } from 'react'
import * as todoActions from '../actions'
import { bindActionCreators } from 'redux'
import { Row, Col } from 'react-bootstrap'

import PiecePanel from './PiecePanel'

class PiecesList extends Component {
  render() {
    const {pieces} = this.props
    return (
      <Row>
        {pieces.map(piece => {
          return <Col md={4}>
            <PiecePanel piece={piece} />
          </Col>
        })}
      </Row>
    )
  }
}
PiecesList.propTypes = {
  pieces: PropTypes.array.isRequired
}

export default PiecesList
