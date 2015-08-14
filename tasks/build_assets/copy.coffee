module.exports = (gulp, {staticFiles}) ->

  gulp.task 'assets:copy', ->
    return unless staticFiles?
    gulp.src(staticFiles).pipe(gulp.dest('build/public'));
