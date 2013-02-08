module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON('package.json')

        meta:
            banner: '/*! <%= pkg.name %> <%= pkg.version %> | (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %> | <%= pkg.license %> License */\n'

        coffee:
            compile:
                expand: true
                cwd: 'src/'
                src: ['**/*.coffee']
                dest: ''
                ext: '.js'

        concat:
            options:
                banner: '<%= meta.banner %>'
            dist:
                src: ['lib/LibroIpsum.js']
                dest: 'lib/LibroIpsum.js'

        uglify:
            options:
                banner: '<%= meta.banner %>'
            dist:
                files:
                    'lib/LibroIpsum.min.js': ['lib/LibroIpsum.js']

        watch:
            files: 'src/**/*.coffee'
            tasks: ['compile']

        docco:
            debug:
                src: ['src/lib/LibroIpsum.coffee']
                dest: 'docs/'

        mocha:
            index: ['test/index.html']
            options:
                run: true

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-docco'
    grunt.loadNpmTasks 'grunt-mocha'

    grunt.registerTask 'compile', ['coffee', 'concat', 'uglify', 'docco', 'mocha']
    grunt.registerTask 'default', ['compile', 'watch']
