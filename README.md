# Guitar Quest

A game for learning classical guitar

TODO:
Deployment
- shared cluster vs single
  - database backups?
- setup https
- download font awesome
- heroku scheduler for challenges

Immediate Features
- notifications
  x figure out clearing isRead for notifications (by clicking link or mark all as read)
    x also, how to highlight that a notification is unread?
  x notification for progressing to next level
  x unique icon for each notification
  x sort notifications newest first
  x limit number queried and paginate them (show more)
- dont query for every userPiece on each level
x grade when waitingToBeGraded changes to false, not when grade changes
x if piece graded multiple times, user gets too much experience
x send comment and grade in one request.
x Include comment in email that is sent to user
- password reset email
- subscription checkout
- flow of upgrading
- use back button for navigating through pieces
  - pieces_by_level/:level
  - pieces/:pieceId
- be able to buy a lesson from a teacher
x how does user enter credit card info if they are still a temp user
- lessons checkout (and use credits)
- 0 index levels (so that level name matches what we see)
- ghost item in piece history
- get rid of all pre save hooks that only execute under certain conditions

Eventually Features
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
