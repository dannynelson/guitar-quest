import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { Panel, ProgressBar } from 'react-bootstrap'
import { connect } from 'react-redux'
import styles from './styles.css'

class PiecePanel extends Component {
  render() {
    const {piece} = this.props
    return (
      <div className={`panel panel-default ${styles.piecePanel}`}>
        <div className={`panel-heading ${styles.pieceHeading}`}>
          <span>0/100</span>
          <span className="pull-right">Completed</span>
        </div>
        <ProgressBar className={styles.progressbar} now={60} />
        <div className='panel-body'>
          <h5 className={styles.pieceTitle}>{piece.name}</h5>
          <div>{piece.composer}</div>
          <div className={styles.pieceEra}>{`${piece.era} era`}</div>
        </div>
      </div>
    )
  }
}
PiecePanel.propTypes = {
  piece: PropTypes.object.isRequired
}

export default PiecePanel
