gulp   = require 'gulp'
util   = require 'gulp-util'
concat = require 'gulp-concat'

smaps  = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
sass   = require 'gulp-ruby-sass'
haml   = require 'gulp-ruby-haml'

newer   = require 'gulp-newer'
changed = require 'gulp-changed'

# 防止编译 coffee 过程中 watch 进程中止
plumber = require("gulp-plumber")

app =
  src:
    js:   'src/js/**/*.coffee'
    css:  'src/css/*.scss'
    html: 'src/html/**/*.haml'
    mobile: 'src/mobile/**/*.haml'
  dist:
    js:   'dist/js'
    css:  'dist/css'
    html: '.'
    mobile: 'mobile'

gulp.task 'js', ->
  gulp.src app.src.js
    .pipe plumber()
    .pipe coffee()
    .pipe gulp.dest(app.dist.js)

gulp.task 'css', ->
  gulp.src app.src.css
    .pipe sass({
        "sourcemap=none": true
    })
    .on 'error', (err)->
      file = err.message.match(/^error\s([\w\.]*)\s/)[1]
      util.log [
        err.plugin,
        util.colors.red file
        err.message
      ].join ' '
    .pipe concat('ui.css')
    .pipe gulp.dest(app.dist.css)

gulp.task 'html', ->
  gulp.src app.src.html
    .pipe haml()
    .on 'error', (err)->
      util.log [
        err.plugin,
        util.colors.red err.message
        err.message
      ].join ' '
    .pipe gulp.dest(app.dist.html)

gulp.task 'mobile', ->
  gulp.src app.src.mobile
    .pipe haml()
    .on 'error', (err)->
      util.log [
        err.plugin,
        util.colors.red err.message
        err.message
      ].join ' '
    .pipe gulp.dest(app.dist.mobile)

gulp.task 'build', ['js', 'css', 'html', 'mobile']
gulp.task 'default', ['build']

gulp.task 'watch', ['build'], ->
  gulp.watch app.src.js, ['js']
  gulp.watch app.src.css, ['css']
  gulp.watch app.src.html, ['html']
  gulp.watch app.src.mobile, ['mobile']