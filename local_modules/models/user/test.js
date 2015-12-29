// Generated by CoffeeScript 1.10.0
(function() {
  var Notification, User, _, database, objectIdString, userFactory;

  require('local_modules/test_helpers/server');

  _ = require('lodash');

  objectIdString = require('objectid');

  database = require('local_modules/database');

  User = require('local_modules/models/user');

  Notification = require('local_modules/models/notification');

  userFactory = require('local_modules/models/user/factory');

  describe('User', function() {
    beforeEach(database.reset);
    it('normalizes email to emailId when email saved', function() {
      return User.create(userFactory.create({
        email: 'Julian.Bream+promotions@Gmail.com'
      })).then(function(user) {
        expect(user).to.have.property('email', 'Julian.Bream+promotions@Gmail.com');
        return expect(user).to.have.property('emailId', 'julianbream@gmail.com');
      });
    });
    return describe('.addPoints()', function() {
      it('validates', function() {
        return User.create(userFactory.create({
          level: 0,
          points: 250
        })).then(function(user) {
          return Promise.all([expect(user.addPoints()).to.eventually.be.rejectedWith('points'), expect(user.addPoints(10.000001)).to.eventually.be.rejectedWith('points')]);
        });
      });
      it('adds points to user', function() {
        return User.create(userFactory.create({
          level: 0,
          points: 250
        })).then(function(user) {
          return user.addPoints(30);
        }).then(function(user) {
          return User.findById(user._id);
        }).then(function(user) {
          expect(user).to.have.property('points', 280);
          return expect(user).to.have.property('level', 0);
        });
      });
      return it('levels up, and notifies if user has sufficient points', function() {
        var userId;
        userId = objectIdString();
        return User.create(userFactory.create({
          _id: userId,
          level: 0,
          points: 250
        })).then(function(user) {
          return Notification.count().then(function(notificationCount) {
            expect(notificationCount).to.equal(0);
            return user.addPoints(2000);
          });
        }).then(function(user) {
          return User.findById(user._id);
        }).then(function(user) {
          expect(user).to.have.property('level', 1);
          return Notification.find();
        }).then(function(notifications) {
          expect(notifications).to.have.length(1);
          expect(_.first(notifications)).to.have.property('type', 'levelUp');
          return expect(_.first(notifications)).to.have.deep.property('params.level', 1);
        });
      });
    });
  });

}).call(this);
