sanitizer = require 'sanitizer'
VOWEL_REPEAT_LENGTH = 10;
END_REPEAT_LENGTH=30;
MIN_LENGTH=10;

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

    templast = ""
    for letter in last
        templast += Array(Math.floor(END_REPEAT_LENGTH/last.length)).join(letter)

    last = templast;

    if(first.length+VOWEL_REPEAT_LENGTH+last.length < MIN_LENGTH)
        VOWEL_REPEAT_LENGTH = END_REPEAT_LENGTH;

    return first+Array(VOWEL_REPEAT_LENGTH).join(middle)+last

  jones: (noun) ->
    noun = sanitizer.escape(noun);
    noun = noun[0].toUpperCase()+noun[1..-1];
    return noun+'. I <b><i>hate</i></b> '+noun+'.';
