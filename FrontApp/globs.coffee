globs = {}

# ------------------------------------ #
# ---------------- src --------------- #
# ------------------------------------ #
globs.coffee = 'src/**/*.coffee'
globs.jade = [
  'src/**/*.jade'
  '!src/index.jade'
]
globs.src = 'src/**/*'
globs.assets = 'src/assets/**/*'
globs.index = "src/index.jade"
globs.vendor = 'vendor/**/*'

# ------------------------------------ #
# --------------- build -------------- #
# ------------------------------------ #
globs.html = [
  'build/**/*.html'
  '!build/index.html'
]
globs.app_js = 'build/app/**/*.js'
globs.app_css = 'build/style/main.css'
globs.common_js = 'build/common/**/*.js'

globs.build = [
  'build/app/**/*.html'
  'build/app/**/*.js'
  'build/common/**/*.js'
  'build/style/**/*.css'
  'build/assets/**'
]

# ------------------------------------ #
# ---------------- bin --------------- #
# ------------------------------------ #
globs.bin = [
  'bin/assets/*.js'
  'bin/assets/*.css'
  'bin/index.html'
]
globs.compiled_assets = 'bin/assets/**'

globs.sass = [
  'src/**/*.scss'
]

globs.vendor_js = [
  'vendor/jquery/dist/jquery.js'
  'vendor/angular/angular.js'
  'vendor/placeholders/angular-placeholders-0.0.1-SNAPSHOT.min.js'
  'vendor/hammerjs/hammer.min.js'
  'vendor/angular-ui-router/release/angular-ui-router.js'
  'vendor/angular-ui-utils/modules/route/route.js'
  'vendor/angular-animate/angular-animate.js'
  'vendor/angular-aria/angular-aria.js'
  'vendor/angular-material/angular-material.js'
  'vendor/angular-mocks/angular-mocks.js'
  'vendor/lodash/dist/lodash.js'
  'vendor/restangular/dist/restangular.js'
  'vendor/angular-typeahead/angular-typeahead.js'
  'vendor/ionrangeslider/js/ion.rangeSlider.js'
  'vendor/angular-bootstrap/ui-bootstrap-tpls.js'
  'vendor/ngInfiniteScroll/build/ng-infinite-scroll.js'
]

globs.karma = globs.vendor_js
  .concat [globs.common_js]
  .concat [globs.app_js]

globs.vendor_css = [
  'vendor/angular-material/angular-material.css'
]
 
globs.app = globs.vendor_js
  .concat globs.vendor_css
  .concat [
    globs.app_js
    globs.common_js
    'build/app/templates.js'
    "!build/app/**/*.spec.js"
    globs.app_css
  ]

globs.js = globs.vendor_js.concat([
  globs.app_js,
  globs.common_js,
  "!build/app/**/*.spec.js"
])

globs.css = [globs.app_css]
  .concat globs.vendor_css

module.exports = globs
