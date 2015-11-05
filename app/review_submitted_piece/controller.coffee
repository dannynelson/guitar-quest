geomoment = require 'geomoment'
_ = require 'lodash'

module.exports = ngInject (UserPiece, User, $stateParams) ->
  @userPiece = UserPiece.get
    _id: $stateParams.userPieceId
    $add: ['user', 'piece']

  @addComment = =>
    user = User.getLoggedInUser()
    if typeof @comment is 'string' and @comment isnt ''
      @userPiece.comments ?= []
      @userPiece.comments.push
        userId: user._id
        text: @comment
        createdAt: geomoment().toDate()
      @userPiece.$update().then =>
        @comment = undefined
        $state.reload()

  @save = (e) =>
    e.preventDefault()
    @userPiece.$update()

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
