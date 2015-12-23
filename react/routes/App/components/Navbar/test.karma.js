import {renderComponent} from 'local_modules/test_helpers/react_component'
import Navbar from './index'
import TestUtils from 'react-addons-test-utils'

describe('Navbar', () => {
  it('calls onNavItemClick with new path when clicked', () => {
    var routeActions = {pushPath: sinon.stub()}
    var $el = renderComponent(<Navbar onNavItemClick={routeActions.pushPath}/>)
    $el.find('.pieces a').click()
    expect(routeActions.pushPath).to.have.been.calledOnce
    $el.find('.hello a').click()
    expect(routeActions.pushPath).to.have.been.calledTwice
  })
})
