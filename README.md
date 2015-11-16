# Guitar Quest

A game for learning classical guitar

TODO:

x send notifcations from a guitarquest email
x update notifications
x handle permissions and restricting pages
x stup email confirmation, and email notifications for piece comments/grades and new quests,
- make sure username and password are secure
x don't include history in default response
x add a banner image and copy to landing page
- follow all deployment and security todos below
x rename quest to challenge everywhere
x email confirmation when subscribing
x update notification text
x create page for adding pieces
- send comment and grade in one request. Include comment in email that is sent to user
x site still logs out pretty frequently (it should almost never log out?)

- password reset email
- error when trying to register twice
- quest credits should be based on level
- create way for people to buy lessons with credits (and schedule the lesson?)
- allow filtering pieces
- always center quests
- clean up account page
- restrict pages and files based on permissions
- lesson payment confirmation, and email unsubscribe page
- send email when quest is created
- once a week clean up temp users
- add about and features on landing page
- restyle the account page to include more info (credits, level, photo?)
- require monthly payment beyond level 2?
- mobile view doesnt work
- title does not populate for a couple seconds on piece page
- handle creating account if user already exists
- total points for level do not update until page refreshed...
- add facebook login as another option
x account page - change password/email, update mailing preferences, etc? - look at a few other sites for inspiration here
x store teacher / student name (and photo?) within profile for easier identification when communicating. Add to comments
x video review page for me
x finish a piece should actually update corresponding quests
* change "teacher feedback" to "comments" in model for more flexibility. Just teacher feedback for now although later we could add user feedback. ability to respond to comments and have a conversation? Should it be a two way conversation? If so, should I ben notified of all the comments? Maybe it's better if they can't leave feedback because it encourages them to take lessons. But what if thye just have a simple question (e.g. what do you mean by this...)
x create data structure for pieces, levels, quests, tutorials, etc.
x completing pieces add experience
x show real name on pieces page
x find static version of progress bar that automatically readjusts for each level
x make leveling up work
x add icons to pending, etc and extract as navbar
x dismiss notifications (and keep track of them somehow)
x make completing quests work
x show notifications when quests or pieces completed

Google auth?

Request video lesson
- create page for signing up for video lesson

Deployment
- configure and deploy to heroku
- mongolab database
- sendgrid
- setup https
- download font awesome
- heroku scheduler for quests

Bug proof
- add access control to review video pages
- consider how everything will possibly break, and handle error cases
- protect endpoints from abuse
- logging service?
- add indexes
- make sure resource schema model save handles pre save hook errors somehow? right now they are being swollowed
- invalid credentials does not show an error.
- add access control to endpoints to make sure random people wont finish pieces by editing json

- stripe integration for subscriptions, and automatic billing
x flesh out user page to allow changing password, show a summary of current level, and all accomplishments
- footer with copyright? other random things?
- recruit previous students to try the app (especially mitch)

Later release
------------------------------------
tutorials
- create page for tutorials
- tutorial/quiz page (save for later release?)

allow recording videos directly in browser
- use sass instead of less so that we can use mixins?
- display user photo next to comments



# Data models

piece

quest

user

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

# recording and saving video
http://stackoverflow.com/questions/16319470/html5-getusermedia-record-webcam-both-audio-and-video
https://truongtx.me/2014/08/09/record-and-export-audio-video-files-in-browser-using-web-audio-api/

# Reward

learn pieces
- learn pieces -> gain exp -> level up -> learn better pieces
- complete quests
  -> unlock special pieces to learn
  -> get lessons to learn more pieces
  ->

# Unlocking Higher Levels (when level 1 is too easy)
assumptions
- most users will already have experience, so they normal use case is to test into a higher level
- we want to show them everything when they first log in, so that
- have them submit a video of some piece they know, and I will place them at the appropriate level...
- make them learn every piece and earn the higher level (if they really are that level, they should be able to finish those peices quickly)
- do you let them see and submit a video for every piece? If so, what is the point of levels if they can just submit any  piece at any time and shortcut the process?

# Quests
Give structure and more specific goals other than just working on pieces
- ensures that the user always has small achievable goals, even if they are far away from reaching the next level
- ensures that user has prepared minimum necessary (tremelo practice, etc, before attempting a harder piece)
- Are they necessary for the MVP? They add a significant amount of complexity

Assumptions
- quests will only be focused on pieces, not tutorials
- rewards should always take current level into consideration. Once user first creates an account, we should try to assess their current level
  - lessons
  - rare pieces (that you can't get anywhere else)
  - certain tutorials that can apply at any level


types
- complete x pieces for this level (only for current level)
  - 5 - free 30 minute skype lesson

- (complete x tutorials)s

- assuming greater than level x, complete x pieces with x technique (e.g. tremolo)
  - temelo
    - 3 recuerdos de la alhambra
  - slurs
    - 3 sunburst (andrew york)
  - arpeggios
    -
- assuming greater than level x, complete x pieces by x composer
  - Fernando Sor
    - 3
    - 5
  - Francisco Tarrego
    - 3
    - Capricho Arabe
  - Bach
    - 3 -
    - 5
  - Villa-Lobos
    - 3
    - 5

rewards (anything that makes the student better at learning pieces)
- free 30 minute lesson - how do a make sure that they do not SPAM this? E.g. they are experienced and they are going through all the free lessons just to unlock new pieces?
  - do not give out free lessons?
  - only give one free lesson to start?
  - give out free lessons sparingly?
- unlock a new piece
- experience? - does not work if they test into higher levels
- unlock new tutorial - does not work if you let them test into higher levels...

# Quests
small, easily achievable goals, based on the user's current level
- encourage
option to decline quest, so that they can get rid of more difficult ones?
- higher credit awarded with each level, since higher level pieces usually take longer to learn
reward - lesson credit
- why not pieces? - b/c workflow is confusing (how do they see which piece they unlocked? what if the piece was an earlier level? And if they don't like the piece, it is not really an award. Easiest if pieces are only unlocked by leveling up).
- why not experience? - b/c realistically, experience only comes from learning pieces
- why not tutorials? - b/c realistically, experience only comes from learning pieces
- why not arbitrary money that they can use to buy subscriptions? - b/c I want them to focus on getting lessons.

Three types of quests
- getting to know the site
  - submit first guitar video
  - complete first tutorial
  - schedule first video lesson (strange to award lesson credit for scheduling lesson?)
- learning a diverse array of pieces at the current level
    learn x pieces of x level with x condition
    - era/style (Renaissance, Baroque, Classical, Romantic, Contemporary)
      - complete 2 level 5 pieces of the Classical Era
    x composer (too specific, the main thing we care about is that the learn pieces from different eras)
      - complete 2 level 5 pieces by Francisco Tarrega
    x technique (slur, tremelo, arpeggio, scales, harmonics, rasgueado, etc.)
      - complete 2 level 5 pieces that use the "Tremelo" technique
      - realistically, not enough pieces focus on just one technique for this to be a practical quest
    x complete any 5 level 3 pieces - too generic, they are doing this anyways to level up. It does not guide their    behavior any differently
- continue to learn easier pieces (sight reading, etc)
  - learn any 5 pieces below your current level
? being a prolific site user
  x submit video x days in a row - easy to game this one. E.g., learn three pieces over a month, then upload them in three subequent days
  ? take x private lessons
  x complete all tutorials? - user doesn't have access to all tutorials until higher level
  ? take lessons from x different teachers - doesn't work while I only have one teacher, maybe later
  x complete pieces of a certain level - pieces will constantly change

strategy
- first, give them all the getting to know the site quests
- after initial, always have 1 prolific user quest
  - when one is finished, automatically replace with another (they are in a specific order so you never see the same twice in a row)
- after initial, always have 2 level-specific quests
  - level specific quests are always presented in a specific order (but never run out)
  - if they advance to new level, add 2 more level specific quests (but keep any ones left over from previous levels)
  - if they complete one of these quests (for the current level, not a previous level), add another one from their current level

Quests and Pieces
- clone for each user, or use canonical copy
- quests - if I change it, I do not want it to ruin the existing quests for all users
  - therefore clone each quests when necessary
- pieces - if I modify it, I want it to update for every user
