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
- lessons checkout (and use credits)
- subscription checkout
- send comment and grade in one request. Include comment in email that is sent to user
- password reset email

Eventually Features
- make credit cards into icons / sprite sheet
- clean up landing page
- allow formatting in comments (and display correctly in both emails and piece history)
- always center quests
- add facebook login as another option

BugFixes / Security
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
------------------------------------
tutorials (public or internal?)
- create page for tutorials
  - since there aren't that many, they could be public facing articles / youtube videos
  - also consider porting all old articles over and redirecting from ClassicalGuitar101 to here
  - can google scrape angular sites? If so,
- allow recording videos directly in browser
- private github repo?
