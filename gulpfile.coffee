
gulp = require 'gulp'

require('./tasks/boot_processes')(gulp)
require('./tasks/build_assets')(gulp, {
  staticFiles: ['public/**']
})
require('./tasks/test')(gulp)
require('./tasks/console')(gulp)

gulp.task 'default', ['build_assets', 'boot_processes']
