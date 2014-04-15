module.exports = (grunt) ->
    "use strict"
    @initConfig(
        pkg: @file.readJSON( 'package.json' )
        clean: 
            dist: ['dist']
        coffee:
            compile:
                options:
                    bare: true
                expand: true
                flatten: false
                cwd: 'src'
                src: ['**/*.coffee']
                dest: 'dist'
                ext: '.js'
        uglify:
            dist:
                files: 
                    'dist/jstree-simplejson.min.js': ['dist/jstree-simplejson.js']
        watch:
            scripts:
                files: ['src/**/*.coffee']
                tasks: ['coffee:compile']
    )

    @loadNpmTasks( 'grunt-contrib-clean' )
    @loadNpmTasks( 'grunt-contrib-coffee' )
    @loadNpmTasks( 'grunt-contrib-uglify' )
    @loadNpmTasks( 'grunt-contrib-watch' )

    @registerTask( 'default', ['clean', 'coffee', 'watch'] )
    @registerTask( 'build', ['clean', 'coffee', 'uglify'] )
    return
