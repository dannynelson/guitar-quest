_ = require 'lodash'
level = require 'local_modules/level'
userPieceHelers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (User, UserPiece, Piece) ->
  @level = level
  @user = User.getLoggedInUser()
  @selectedLevel = @user.level
  @levelHelper = level

  tour = new Tour
    steps: [
      {
        path: '/#/pieces'
        element: ".gq-navbar",
        placement: 'bottom'
        title: "Welcome to GuitarQuest!",
        content: "GuitarQuest is an online game for learning classical guitar."
      },
      {
        path: '/#/pieces'
        element: ".gq-navbar .pieces"
        placement: 'bottom'
        content: "In the Pieces section, you will find a collection of classical guitar pieces that you can learn."
      },
      {
        path: '/#/pieces'
        element: ".user-level",
        placement: 'right'
        content: "Right now, you are viewing all Level 1 pieces."
      }
      {
        path: '/#/pieces'
        element: ".piece:nth-child(1) .piece-points",
        content: "For each piece that you learn, you will earn points."
      }
      {
        path: '/#/pieces'
        element: ".points-to-next-level",
        placement: 'left'
        content: "Once you earn 2000 points, you will progress to Level 2 and unlock new, more challenging pieces."
      }
    ]

  @getStatus = (userPiece) ->
    return unless userPiece?
    userPieceHelers.getStatus()
  UserPiece.query({userId: @user._id}).$promise.then (userPieces) =>
    @userPieceByPieceId = _(userPieces)
      .indexBy('pieceId')
      .value()

  setPieces = (level) =>
    @pieces = Piece.query({level})
    @pieces.$promise.then =>
      tour.init()
      tour.start()
    @levelPoints =
      piece: @levelHelper.getPointsPerPiece(@selectedLevel)
      completed: @levelHelper.calculatePointsIntoLevel(@user.points, @selectedLevel)
      total: @levelHelper.getTotalLevelPoints(@selectedLevel)

  setPieces(@selectedLevel)

  @goToNextLevel = =>
    @selectedLevel++
    setPieces(@selectedLevel)

  @goToPreviousLevel = =>
    @selectedLevel--
    setPieces(@selectedLevel)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
