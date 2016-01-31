# Guitar Quest

A game for learning classical guitar

Do we need challenges?
- Yes, it helps people **decide what to work on next** when they have so many options available
- Helps people become well-rounded musicians. Encourages them to work on pieces they might otherwise skip
What is the reward for challenges? Something that will help them learn pieces.
* access to music
  - unlock pieces - we already unlock pieces with points. Maybe unlock special pieces that you couldn't normally access in the book
  - earn points - to help you progress to the next level faster. Completing challenges helps you progress as a musician
* access to private lessons
  - free lessons - too time consuming and valuable
  - credits for free lessons - was not motiviating to Chuck. Also, feels weird associating rewards with real money
* access to tutorials and video recordings
  - unlock special tips and tutorials - could be nice, but I need to create them first ;)
* access to physical resources (strings, guitar, etc)
  - I ship them strings, etc. - there's no way

TODO:
Deployment

Immediate Features
- notification that email has been confirmed
- notifications flash twice when initially displaying
- availability of challenges will be an issue (especially on earlier levels)
  - should challenges be staged?
- rollbar and sumo logic
- build flow for buying a private lesson
  - for applying credits to lessons
  - http://stackoverflow.com/questions/22895725/how-can-i-give-a-customer-a-non-refundable-credit-towards-their-subscription-usi
- test all business logic on server, use angular validated resource
- deploy and populate Level 1, Level 2 pieces
- update submission guideline text
- host images on S3, clear git history
- quick pass to make sure everything looks ok on mobile
- setup real guitarquest email address - pending (try again at 5:30)
  - probably want to eventually buy an account so that I can send emails directly from there
  - does this allow me to set the sender name
  - eventually the email should look like pivotat, meetup, or facebook
  - https://sendgrid.com/docs/User_Guide/Legacy_Features/Marketing_Emails/sender_address.html
- is professional account the right name?
- add accents to composer names. Are accents searchable in the same way?
- 'earn points based on how you did'
- confirmation email after subscribing
- something on landing page about the pieces they will learn in the curriculum
- update subscription to be $29
- Piece page should be
  - piece notes?
  - example submission / recording (of me playing)
  - recommended tutorials for that piece (or for that level)
  - sheet music
  - record video for all Preparatory level pieces
- share password and email validation logic?
- show error for old/invalid login request token

- ng-disabled on payments for after submitting
- password reset email
- subscription checkout
- flow of upgrading
- be able to buy a lesson from a teacher
- lessons checkout (and use credits)
- 0 index levels (so that level name matches what we see)
- get rid of all pre save hooks that only execute under certain conditions
- link to submitted video should actually allow you to see the submitted video on the webiste
- move everything into domains
- returning to confirm email after you have already confirmed should redirect you if you are logged in, or user already exists
- still a delay in updating points when return to home page...
- emailId not indexed in mongolab?

Eventually Features
- throw different error for each of the status codes
- restrict video upload on S3 side - also test upload restrictions in UI
- set cookie max age so it persists pass browser session? - also, try to understand how the cookies work
- rolling deploys
- add tips to help them learn the site while the video is uploading
- consider allowing more than 1GB and more than 15 minutes?
  - what is a reasonable upper limit we can expect
- a more obvious link for submitting another video
- add page icon
- heroku scheduler for challenges
- download font awesome
- setup mongolab backups http://docs.mongolab.com/backups/
- display the SSL badge that I was emailed in the navbar?
- editing stripe card should not overwrite existing stripe user
- some emphasis on learn as you go in the tutorial
- some kind of user terms for signing up / taking lessons?
- be able to unsubscribe
- how to authenticate and test server side with request?
- registering when piece already exists
- beef up profile/account page
  - name, current level, current points, photo?
  - current subscription level
  - # pieces submitted
  - # challenges completed
  - card info
- full height and width images on login page
- prevent brute forcing login
- lock account if there are too many failed password attempts
- clean up dependencies that should really be dev dependencies
- sign up, sign in, and confirm email should not display navigation (just brand link)
- normalize user fist name, last name and email
- when to use mongo vs sql?
- setup email
- hide notifactions when clicking away
- way to cancel subscription once subscribed
- upgrade to latest ui bootstrap
- add rollbar
- add sumo logic
- add json schema validation to all requests
- access denied or redirect if user does not have permission
- allow formatting user feedback
- saving one card then changin it??
- handle expired credit cards
- opt into no auth rather than opt into auth (so that I don't forget to secure pages)
- add a yearly account option?
- make credit cards into icons / sprite sheet
- clean up landing page
- allow formatting in comments (and display correctly in both emails and piece history)
- always center quests
- add facebook login as another option
- landing page, login and sign up should be a static page, not part of the angular app
- login in link underlines after click
- forgot password (and email?) flow
- hide most of submission guidelines (since once they know once, they won't need to see it again)
- clean up duplicate loading of piece in pre save and post save hooks
- infinite scroll for notifications
- will query param length for userPieces ever go beyond url limit on piecesByLevel page?
- notification that let's users know there has been an update
- allow noavigating through levels even if user does not have access yet? (so that navigation always remains the same)
- clarify text when user already finished level
- clean up CSS
- provide help for all errors (especially video upload) - if problem persists, please contact, we've been notified
- compress video to transfer?
- validate video upload with built-in validation

BugFixes / Security
- what happens if we can't connect to stripe
- have some way of capturing and tracking all errors that happen on client
- use boom everywhere
- separate subscriptions from user?
- add auth requirements to user endpoints
- landing image should be smaller (or loaded more gracefully) and served from S3.
- mobile view doesnt work
- do not allow level to go backwards if user points modified
- add tests for everyting
- error when trying to register twice
- restrict pages and files based on permissions
- quest credits should be based on level
- allow filtering pieces
- clean up account page
- lesson payment confirmation, and email unsubscribe page
- send email when quest is created doesnt work
- once a week clean up temp users
- add about and features on landing page
- restyle the account page to include more info (credits, level, photo?)
- title does not populate for a couple seconds on piece page
- handle creating account if user already exists (cryptic error right now)
- total points for level do not update until page refreshed...

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
- footer with copyright? other random things?
- recruit previous students to try the app (especially mitch)

Later release
- dynamic height textarea (not user facing so not a big deal)
- allow sending video feedback?
------------------------------------
tutorials (public or internal?)
- make landing page more mobile friendly (100% width image, relative units instead of pixels. Like google wallet landing page)
- create page for tutorials
  - since there aren't that many, they could be public facing articles / youtube videos
  - also consider porting all old articles over and redirecting from ClassicalGuitar101 to here
  - can google scrape angular sites? If so,
- allow recording videos directly in browser
- private github repo?
