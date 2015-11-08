geomoment = require 'geomoment'
_ = require 'lodash'
level = require 'local_modules/level'
userPieceHelpers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (UserPiece, Piece, User, $stateParams) ->
  @level = level
  @userPiece = UserPiece.get
    _id: $stateParams.userPieceId
    $add: ['user', 'piece', 'historyChanges']
  @userPiece.$promise.then =>
    @piece = Piece.get({_id: @userPiece.pieceId})
    loadVideo(@userPiece.submissionVideoURL)
    @userGrade = (@userPiece.grade || 0) * 10
    updatePercent(@userGrade)

  @getStatus = (userPiece) ->
    userPieceHelpers.getStatus(userPiece)

  @max = 10
  @comment = null

  updatePercent = (grade) =>
    @percent = 100 * (grade / @max)

  @onHover = (grade) =>
    @overStar = grade
    updatePercent(grade)

  @onLeave = =>
    @overStar = null
    updatePercent(@userGrade)

  @submitGrade = =>
    grade = @userGrade / 10
    @userPiece.$grade({grade})

  @submitComment = =>
    return unless typeof @comment is 'string' and @comment.length
    @userPiece.comment = @comment
    @comment = null
    @userPiece.$update()

  videoPreview = document.querySelector('video')

  loadVideo = (videoUploadSrc) =>
    videoPreview.src = videoUploadSrc
    videoPreview.load()

  @save = (e) =>
    e.preventDefault()
    @userPiece.$update()

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
