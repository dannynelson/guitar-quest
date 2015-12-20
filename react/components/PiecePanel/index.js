import React, { Component, PropTypes } from 'react'
import * as todoActions from '../../actions'
import { bindActionCreators } from 'redux'
import { Panel, ProgressBar } from 'react-bootstrap'
import styles from './style.css'

console.log('TEST', styles.progressbar)
debugger

import { connect } from 'react-redux'

class PiecePanel extends Component {
  render() {
    const {piece} = this.props
    return (
      <div className='panel panel-default'>
        <div className='panel-heading'>0/100</div>
        <ProgressBar className={styles.progressbar} now={60} />
        <div className='panel-body'>
          <h5>{piece.name}</h5>
          <p>{piece.composer}</p>
        </div>
      </div>
    )
  }
}
PiecePanel.propTypes = {
  piece: PropTypes.object.isRequired
}

export default PiecePanel
