geomoment = require 'geomoment'
_ = require 'lodash'
levelHelper = require 'local_modules/level'
ObjectId = require 'objectid-browser'
userPieceHelpers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece, UserPiece, $state, $q, $timeout, errorHelper) ->
  @levelHelper = levelHelper
  uploadPromise = null
  @getStatus = (userPiece) ->
    userPieceHelpers.getStatus(userPiece)
  user = User.getLoggedInUser()

  @loadingPiece = true
  $q.all [
    UserPiece.query({pieceId: $stateParams.pieceId, userId: user._id, $add: ['historyChanges']}).$promise
    Piece.get({_id: $stateParams.pieceId}).$promise
  ]
  .then ([userPieces, @piece]) =>
    @userPiece =
      if userPieces.length is 0
        userPiece = new UserPiece
          _id: new ObjectId().toString()
          pieceId: $stateParams.pieceId
          userId: user._id
          historyChanges: [] # so that server will return the changes when we first submit a video
      else
        _.first(userPieces)
  .finally =>
    @loadingPiece = false
    loadVideo(@userPiece.submissionVideoURL) if @userPiece.submissionVideoURL?

  loadVideo = (videoUploadSrc) =>
    $timeout ->
      videoPreview = document.querySelector('video')
      videoPreview.src = videoUploadSrc
      videoPreview.load()

  @getSpotifySrc = =>
    "https://embed.spotify.com/?uri=#{@piece.spotifyURI}"

  @abortUpload = =>
    uploadPromise?.abort()

  @upload = (file) =>
    return unless file?
    s3Params = null
    [fileName, fileSuffix] = file.name.split('.')
    fileName = file.name = "piece_#{@piece._id}_#{new ObjectId().toString()}.#{fileSuffix}"

    Upload.mediaDuration(file).then (durationInSeconds) =>
      oneGB = 1000000000 # in bites
      if file.size > oneGB
        throw new errorHelper.UserInputError 'Video must be smaller than 1 GB'
      fifteenMinutes = 900 # seconds
      if durationInSeconds > fifteenMinutes
        throw new errorHelper.UserInputError 'Video must be under 15 minutes'
      @uploading = true
      $http.get('/s3_policy?mimeType='+ file.type)
    .then (response) =>
      s3Params = response.data
      uploadPromise = Upload.upload
        url: s3Params.bucketURL
        method: 'POST'
        fields:
          key: "user_#{user._id}/#{fileName}"
          AWSAccessKeyId: s3Params.AWSAccessKeyId
          acl: 'public-read'
          policy: s3Params.policy
          signature: s3Params.signature
          "Content-Type": if file.type isnt '' then file.type else 'application/octet-stream'
        file: file
    .then null, null, (evt) => # progress
      @progressPercentage = progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
    .then =>
      videoUploadSrc = "#{s3Params.bucketURL}/user_#{user._id}/#{fileName}"
      loadVideo(videoUploadSrc)
      @userPiece.$submitVideo({submissionVideoURL: videoUploadSrc})
    .catch errorHelper.UserInputError, (err) =>
      debugger
      @videoUploadError = err.message
    .catch (err) =>
      debugger
      @videoUploadError = 'Something went wrong uploading the video to our server. Please try again later.'
    .finally =>
      debugger
      @progressPercentage = 0
      @uploading = false
      uploadPromise = null

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
