gulp = require 'gulp'
gutil = require 'gulp-util'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
inject = require 'gulp-inject'
karma = require 'gulp-karma'
changed = require 'gulp-changed'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
globs = require './globs'
series = require 'stream-series'
path = require('path')
filter = require('gulp-filter')
concat = require('gulp-concat')
rename = require('gulp-rename')
gulpif = require('gulp-if')
url = require('url')
proxy = require('proxy-middleware')
templateCache = require('gulp-angular-templatecache')
uglify = require('gulp-uglify')
clean = require('gulp-clean')
runSequence = require('run-sequence')
minifyCss = require('gulp-minify-css')
livereload = require('gulp-livereload')
p = require('./package.json')
v = p.version

# Paths
index_path = 'build/index.html'
src_dir = 'src/'

build_dir = 'build/'
build_app_dir = 'build/app/'
build_vendor_dir = 'build/vendor/'
build_assets_dir = 'build/assets/'

compile_dir = 'bin/'
compile_assets_dir = 'bin/assets/'



# ------------------------------------ #
# ------------- clean ---------------- #
# ------------------------------------ #
gulp.task 'clean:build', ->
  gulp.src(globs.build, read: false)
  .pipe(clean(force: true))

gulp.task 'clean:bin', ->
  gulp.src(globs.bin, read: false)
  .pipe(clean(force: true))

gulp.task 'clean', ['clean:bin', 'clean:build']


# ------------------------------------ #
# ------------- build ---------------- #
# ------------------------------------ #
gulp.task 'build:jade', ->
	gulp.src globs.jade
    .pipe plumber()
    .pipe jade({ pretty : true })
    .pipe gulp.dest(build_dir)
    .pipe connect.reload()

gulp.task 'build:index', ->
  gulp.src 'build/index.html'
    .pipe plumber()
    .pipe inject(gulp.src(globs.app, { read : false }), { ignorePath : ['build'], addRootSlash : false })
    .pipe gulp.dest(build_dir)

gulp.task 'build:templateCache', ->
  gulp.src globs.html
    .pipe plumber()
    .pipe templateCache()
    .pipe gulp.dest(build_app_dir)
    .pipe connect.reload()

gulp.task 'build:sass', ->
  gulp.src globs.sass
    .pipe plumber()
    .pipe(concat('main.scss'))
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(sourcemaps.write())
    .pipe(rename (path)->
      path.dirname = '/style'
      path
    )
    .pipe gulp.dest(build_dir)
    .pipe connect.reload()

gulp.task 'build:coffee', ->
	gulp.src globs.coffee
    .pipe plumber()
    .pipe coffee({ bare : true })
    .pipe gulp.dest(build_dir)
    .pipe connect.reload()

gulp.task 'build:assets', ->
	gulp.src globs.assets
    .pipe plumber()
    .pipe gulp.dest(build_assets_dir)
    .pipe connect.reload()

gulp.task 'build:vendor', ->
	gulp.src globs.vendor
    .pipe plumber()
    .pipe gulp.dest(build_vendor_dir)
    .pipe connect.reload()

gulp.task 'run:karma', ->
	gulp.src globs.karma
    .pipe karma
      configFile : 'karma.conf.js'
      action : 'watch'
    .on 'error', (err) ->
      throw err
      return

gulp.task 'run:karmaonce', ->
	gulp.src globs.karma
    .pipe karma
      configFile : 'karma.conf.js'
      action: 'run'
    .on 'error', (err) ->
      throw err
      return


# ------------------------------------ #
# ------------ compile --------------- #
# ------------------------------------ #
gulp.task 'compile:javascript', ->
  gulp.src globs.js
    .pipe plumber()
    .pipe(concat('app-' + v + '.js'))
    .pipe(uglify())
    .pipe(gulp.dest(compile_assets_dir))

gulp.task 'compile:css', ->
  gulp.src globs.css
    .pipe plumber()
    .pipe minifyCss()
    .pipe(concat('app-' + v + '.css'))
    .pipe(gulp.dest(compile_assets_dir))

gulp.task 'compile:assets', ->
	gulp.src globs.assets
    .pipe(plumber())
    .pipe(gulp.dest(compile_assets_dir))

gulp.task 'compile:index', ->
	gulp.src globs.index
    .pipe plumber()
    .pipe jade({ pretty : true })
    .pipe inject(gulp.src(globs.compiled_assets, { read : false }), { ignorePath : ['bin'], addRootSlash : false })
    .pipe gulp.dest(compile_dir)


# ------------------------------------ #
# ---------- development ------------- #
# ------------------------------------ #
`
gulp.task('connect', function(){
    connect.server({
        root: ['build'], 
        livereload: true,
        middleware: function(connect, o) {
          return [ (function() {
            var url = require('url');
            var proxy = require('proxy-middleware');
            var options = url.parse('http://localhost:3000/api');
            options.route = '/api';
            return proxy(options);
          })()]
        }
    });
});
`

gulp.task 'watch', ()->
  gulp.watch globs.jade, ['build:jade']
  gulp.watch globs.assets, ['build:assets']
  gulp.watch globs.sass, ['build:sass']
  gulp.watch globs.coffee, ['build:coffee']
  gulp.watch globs.karma, ['run:karma']


# ------------------------------------ #
# ---------- global tasks ------------ #
# ------------------------------------ #

# development build
gulp.task 'build', ()->
  runSequence(
    'clean:build'
    ['build:vendor', 'build:sass', 'build:assets', 'build:coffee', 'build:jade']
    'build:templateCache'
    'build:index'
    'run:karmaonce'
  )

# production build
gulp.task 'compile', ()->
  runSequence(
    'clean:build'
    'clean:bin'
    ['build:vendor', 'build:sass', 'build:assets', 'build:coffee', 'build:jade']
    'build:templateCache'
    ['compile:assets', 'compile:javascript', 'compile:css']
    'compile:index'
    'run:karmaonce'
  )

# dev build + unit tests
gulp.task 'test', ()->
  runSequence(
    'clean:build'
    ['build:vendor', 'build:sass', 'build:assets', 'build:coffee', 'build:jade']
    'build:templateCache'
    'build:index'
    'run:karmaonce'
  )

# connect and watch 
gulp.task 'default', ->
  runSequence(
    'clean:build'
    ['build:vendor', 'build:sass', 'build:assets', 'build:coffee', 'build:jade']
    'build:templateCache'
    'build:index'
    'run:karmaonce'
    ['connect', 'watch']
  )

