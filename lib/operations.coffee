sanitizer = require 'sanitizer'
REPEAT_LENGTH = 100;

module.exports = 
  khan: (name) ->
    name = sanitizer.escape(name.toUpperCase());
    vowels = ['A','E','I','O','U','Y'];
    last_vowel_index = 0;

    for vowel in vowels
        index = name.lastIndexOf vowel;
        if index>last_vowel_index
            last_vowel_index = index;

    first = name.substring 0, last_vowel_index;
    middle = name.substring last_vowel_index, last_vowel_index+1;
    last = name.substring last_vowel_index+1;

    return first+Array(REPEAT_LENGTH).join(middle)+last

  jones: (noun) ->
    noun = sanitizer.escape(noun);
    noun = noun[0].toUpperCase()+noun[1..-1];
    return noun+'. I <b><i>hate</i></b> '+noun+'.';