geomoment = require 'geomoment'
_ = require 'lodash'
levelHelper = require 'local_modules/level'
ObjectId = require 'objectid-browser'
userPieceHelpers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece, UserPiece, $state, $q, $timeout) ->
  @levelHelper = levelHelper
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
        new UserPiece
          _id: new ObjectId().toString()
          pieceId: $stateParams.pieceId
          userId: user._id
          status: 'unfinished'
          historyChanges: [] # so that server will return the changes when we first submit a video
      else
        userPieces[0]
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

  @upload = (file) =>
    return unless file?
    @uploading = true
    [fileName, fileSuffix] = file.name.split('.')
    fileName = file.name = "piece_#{@piece._id}_#{new ObjectId().toString()}.#{fileSuffix}"

    $http.get('/s3_policy?mimeType='+ file.type).then (response) =>
      s3Params = response.data
      Upload.upload
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
      .progress (evt) =>
        @progressPercentage = progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name)
      .success (data, status, headers, config) =>
        @progressPercentage = 0
        @uploading = false
        videoUploadSrc = "#{s3Params.bucketURL}/user_#{user._id}/#{fileName}"
        @userPiece.submissionVideoURL = videoUploadSrc
        loadVideo(videoUploadSrc)
        console.log('file ' + config.file.name + 'uploaded. Response: ' + data)

        @userPiece.$update()
        # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

      .error (data, status, headers, config) ->
        @progressPercentage = 0
        @uploading = false
        # ngToast.success 'Oops! Something went wrong uploading the video. Please try another file.'
        console.log('error status: ' + status)

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
