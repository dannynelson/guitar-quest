geomoment = require 'geomoment'
_ = require 'lodash'
level = require 'local_modules/level'
userPieceHelpers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (UserPiece, Piece, User, $stateParams) ->
  @level = level
  @userPiece = UserPiece.get
    _id: $stateParams.userPieceId
    $add: ['user', 'piece']
  @userPiece.$promise.then =>
    @piece = Piece.get({_id: @userPiece.pieceId})
    loadVideo(@userPiece.submissionVideoURL)
    @userGrade = (@userPiece.grade || 0) * 10
    updatePercent(@userGrade)

  @getStatus = (userPiece) ->
    userPieceHelpers.getStatus(userPiece)

  @max = 10

  updatePercent = (grade) =>
    @percent = 100 * (grade / @max)

  @onHover = (grade) =>
    @overStar = grade
    updatePercent(grade)

  @onLeave = =>
    @overStar = null
    updatePercent(@userGrade)


  @submitGrade = =>
    @userPiece.grade = @userGrade / 10
    @userPiece.waitingToBeGraded = false
    @userPiece.$update()


  videoPreview = document.querySelector('video')

  loadVideo = (videoUploadSrc) =>
    videoPreview.src = videoUploadSrc
    videoPreview.load()

  @addComment = =>
    user = User.getLoggedInUser()
    if typeof @comment is 'string' and @comment isnt ''
      @userPiece.history ?= []
      @userPiece.history.push
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
