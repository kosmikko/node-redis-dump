
fs      = require 'fs'
path    = require 'path'
argv    = require('optimist').argv
dump    = require './dump'
package = JSON.parse fs.readFileSync path.normalize(__dirname+'/../package.json'), 'utf8'

if argv.help
    console.log """
        #{package.name} #{package.version}

        Usage: #{package.name} [OPTIONS]
          -h <hostname>    Server hostname (default: 127.0.0.1)
          -p <port>        Server port (default: 6379)
          -f <filter>      Query filter (default: *)
          --help           Output this help and exit

        Examples:
          redis-dump
          redis-dump -p 6500
          redis-dump -f 'mydb:*' > mydb.dump.txt

        The output is a valid list of redis commands.
        That means the following will work:
          redis-dump > dump.txt      # Dump redis database
          cat dump.txt | redis-cli   # Import redis database from generated file

        """
else
    params =
        filter: argv.f ? '*'
        port:   argv.p ? 6379
        host:   argv.h ? '127.0.0.1'
    
    dump params, (err, result) ->
        if err? then return process.stderr.write "#{err}\n"
        if result? and "#{result}".replace(/^\s+/, '').replace(/\s+$/, '') isnt ''
            console.log result