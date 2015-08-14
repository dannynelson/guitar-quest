
gulp = require 'gulp'

require('./tasks/boot_processes')(gulp)
require('./tasks/build_assets')(gulp, {
  staticFiles: ['node_modules/ngToast/dist/ngToast.css', 'public/bootstrap.min.css', 'public/hover-min.css', 'public/guitar.jpg']
})
require('./tasks/test')(gulp)
require('./tasks/console')(gulp)

gulp.task 'default', ['build_assets', 'boot_processes']
