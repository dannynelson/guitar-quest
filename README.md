# Guitar Quest

A game for learning classical guitar



TODO:

- upload videos, and send to youtube (or vimeo) API
- allow recording videos directly in browser
- create data structure for pieces, levels, quests, tutorials, etc.
- configure heroku
- sendgrid - email verification and automatic email communication when pieces reviewed, skype lessons requested, skype lessons approved, etc. (or is there a better solution)
- stripe integration for subscriptions, and automatic billing
- flesh out user page to allow changing password, show a summary of current level, and all accomplishments
- footer with copyright? other random things?
- recruit previous students to try the app (especially mitch)
- setup https

http://havecamerawilltravel.com/photographer/how-allow-public-access-amazon-bucket

# video hosting solutions

http://stackoverflow.com/questions/4772215/video-hosting-platform-or-cdn-with-streaming-video-which-and-why
Amazon AWS S3 upload -> https://github.com/danialfarid/ng-file-upload

## Video Hosting
youtube
- free, but has advertisements? Can is there a premium version that allows you to disable that?
- oauth flow -> google requests access to their account, then uploads the video to their youtube account
- pros
  - youtube videos = free marketing? How will we know it is from guitar quest?
  - free
cons
  - adds, more friction to uploading. I don't own the content
vimeo
- oauth
vzaar

## CDN/s3 + Video player
http://stackoverflow.com/questions/3505612/amazon-s3-hosting-streaming-video
http://stackoverflow.com/questions/17585881/amazon-s3-direct-file-upload-from-client-browser-private-key-disclosure
https://github.com/nukulb/s3-angular-file-upload

directly upload to s3
video.js
flowplayer

## File Processing Service
transloadit - http://transloadit.com/
zencoder - https://zencoder.com/en/
pandastream

Video JS for video playback

recording and saving video
http://stackoverflow.com/questions/16319470/html5-getusermedia-record-webcam-both-audio-and-video


