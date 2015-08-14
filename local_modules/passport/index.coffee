passport = require('passport')
LocalStrategy = require('passport-local').Strategy
User = require 'local_modules/models/user'

passport.use(User.createStrategy())
passport.serializeUser(User.serializeUser())
passport.deserializeUser(User.deserializeUser())

module.exports = passport
