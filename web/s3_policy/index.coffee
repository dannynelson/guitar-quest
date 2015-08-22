geomoment = require 'geomoment'
crypto = require 'crypto'

module.exports = router = require('express').Router()

###
To sign your form you need to perform two steps:
1. Base64-encode the policy document, and include it in the form’s policy input field.
2. Calculate a signature value (SHA-1 HMAC) from the encoded policy document using your AWS Secret Key credential as a password. Include this value in the form’s signature input field after Base64-encoding it.
###

router.get '/', (req, res, next) ->
  return res.status(400).send('mimeType query param required') unless req.query.mimeType

  policyJSON = JSON.stringify
    expiration: geomoment().add(1, 'day').toDate().toISOString()
    conditions: [
      {"bucket": "guitar-quest-videos"},
      ["starts-with", "$key", "user_#{req.user._id.toString()}/"],
      {"acl": "public-read"},
      ["starts-with", "$Content-Type", req.query.mimeType],
      # {'success_action_status' : '201'}
    ]
  base64Policy = new Buffer(policyJSON, 'utf-8').toString('base64')
  signature = crypto.createHmac('sha1', process.env.AWS_SECRET_ACCESS_KEY)
    .update(new Buffer(base64Policy, 'utf-8'))
    .digest('base64')
  AWSAccessKeyId = process.env.AWS_ACCESS_KEY_ID
  res.json {
    bucketURL: 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com'
    policy: base64Policy
    signature: signature
    AWSAccessKeyId: AWSAccessKeyId
  }
