module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON('package.json')

        meta:
            banner: '/*! <%= pkg.name %> <%= pkg.version %> | (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %> | <%= pkg.license %> License */\n'

        coffee:
            compile:
                files:
                    'lib/LibroIpsum.js' : 'src/LibroIpsum.coffee'

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
            files: 'src/LibroIpsum.coffee'
            tasks: ['compile']

        docco:
            debug:
                src: ['lib/LibroIpsum.js']
                dest: 'docs/'

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-docco'

    grunt.registerTask 'compile', ['coffee', 'concat', 'uglify', 'docco']
    grunt.registerTask 'default', ['compile', 'watch']
