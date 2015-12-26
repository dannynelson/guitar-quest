import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { Panel, ProgressBar } from 'react-bootstrap'
import styles from './style.css'

import { connect } from 'react-redux'

class PageLoader extends Component {
  render() {
    return (
      <div className={styles.loaderContainer}>
        <i className="fa fa-refresh fa-4x fa-spin"></i>
      </div>
    )
  }
}

export default PageLoader
