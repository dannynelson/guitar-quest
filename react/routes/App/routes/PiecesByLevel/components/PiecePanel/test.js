import 'local_modules/test_helpers/react_shallow_render'
import React from 'react'
import TestUtils from 'react-addons-test-utils'
import PiecePanel from './index'
import pieceFactory from 'local_modules/models/piece/factory'

function setup(props) {
  let renderer = TestUtils.createRenderer()
  renderer.render(<PiecePanel {...props} />)
  let output = renderer.getRenderOutput()
  return {
    props,
    output,
    renderer
  }
}

describe('PiecePanel component', function() {
  it('renders correctly', () => {
    const piece = pieceFactory.create({
      name: 'Study in B Minor',
      composer: 'Fernando Sor',
      era: 'classical'
    })
    const {output} = setup({piece})
    let [panelHeading, progressbar, panelBody] = output.props.children
    let [pieceName, composer, era] = panelBody.props.children
    expect(pieceName.props.children).to.equal('Study in B Minor')
    expect(composer.props.children).to.equal('Fernando Sor')
    expect(era.props.children).to.equal('classical era')
  })
})
