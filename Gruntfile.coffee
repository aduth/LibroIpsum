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

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'compile', ['coffee', 'concat']
    grunt.registerTask 'default', ['compile', 'watch']
    grunt.registerTask 'release', ['compile', 'uglify']
