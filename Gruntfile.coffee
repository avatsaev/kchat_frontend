module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-bower-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-haml2html'
  grunt.loadNpmTasks 'js-obfuscator'


  grunt.initConfig

    sass:
      options:
        style: 'expanded'
      dist:
        files:
          'public/stylesheets/bundle.css': 'app/sass/bundle.sass'

    coffee:
      joined:
        options:
          join: true
          bare: true
        files:
          'public/javascripts/bundle.js': ['app/coffee/**/*.coffee']

    haml:
      all:
        options:
          style: 'expanded'
        files: [
          expand: true,
          cwd:'app/views'
          src: '**/*.haml'
          dest: 'public/views'
          ext : '.html'
        ]


    cssmin:
      target:
        files: [
          expand: true
          cwd: 'public/stylesheets'
          src: [
            'bundle.css'
            'lib.css'
            '!*.min.css'
          ]
          dest: 'public/stylesheets'
          ext: '.min.css'
        ]

    uglify:
      all:
        options:
          mangle: true
          compress: true
        files:
          'public/javascripts/lib.min.js': ['public/javascripts/lib.js']
          'public/javascripts/bundle.min.js': ['public/javascripts/bundle.js']

    jsObfuscate:
      all:
        options:
          concurrency: 2
          keepLinefeeds: false
          keepIndentations: false
          encodeStrings: true
          encodeNumbers: true
          moveStrings: true
          replaceNames: true
          variableExclusions: [
            '^_get_'
            '^_set_'
            '^_mtd_'
          ]
        files: 'public/javascripts/bundle.min.js': [
          'public/javascripts/bundle.min.js'
        ]

    watch:
      coffee:
        files: [ 'app/coffee/**/*.coffee' ]
        tasks: [ 'coffee:joined']
        options:
          spawn: false
          livereload: true

      sass:
        files: ['app/sass/**/*.sass']
        tasks: [ 'sass']
        options:
          spawn: false
          livereload: true

      haml:
        files: 'app/views/**/*.haml'
        tasks: ['haml:all']
        options:
          spawn: false
          livereload: true


    bower_concat:

      all:
        dest:
          js: "public/javascripts/lib.js"
          css: "public/stylesheets/lib.css"
         mainFiles:
          bootstrap: 'dist/css/bootstrap.css'

        dependencies:
          'bootstrap-datepicker': 'bootstrap'
          'angular-bootstrap':    'angular'
          'angular-touch':        'angular'
          'angular-animate':      'angular'



  grunt.registerTask 'default', [
    'assets',
    'watch'
  ]

  grunt.registerTask 'assets', [
    'sass'
    'cssmin'
    'coffee:joined'
    'haml:all'
    'bower_concat:all'
    'uglify:all'
    'jsObfuscate:all'
  ]
