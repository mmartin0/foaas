sanitizer = require 'sanitizer'
REPEAT_LENGTH = 100;

module.exports = 
  khan: (name) ->
    name = name.toUpperCase();
    return sanitizer.escape(name)+Array(REPEAT_LENGTH).join(sanitizer.escape(name)[sanitizer.escape(name).length-1])

  jones: (noun) ->
    noun = sanitizer.escape(noun);
    noun = noun[0].toUpperCase()+noun[1..-1];
    return noun+'. I <i>hate</i> '+noun+'.';