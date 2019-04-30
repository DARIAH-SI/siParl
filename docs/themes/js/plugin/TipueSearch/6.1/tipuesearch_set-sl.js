
/*
Tipue Search 6.1
Copyright (c) 2017 Tipue
Tipue Search is released under the MIT License
http://www.tipue.com/search
*/

/* Dodal spodaj slovenske prevode. TODO: uredi za slovenščino stop words ipd. */

/*
Stop words
Stop words list from http://www.ranks.nl/stopwords
*/

var tipuesearch_stop_words = [];


// Word replace

var tipuesearch_replace = {'words': [
     {'word': 'tip', 'replace_with': 'tipue'},
     {'word': 'javscript', 'replace_with': 'javascript'},
     {'word': 'jqeury', 'replace_with': 'jquery'}
]};


// Weighting

var tipuesearch_weight = {'weight': [
     {'url': 'http://www.tipue.com', 'score': 20},
     {'url': 'http://www.tipue.com/search', 'score': 30},
     {'url': 'http://www.tipue.com/is', 'score': 10}
]};


// Illogical stemming

var tipuesearch_stem = {'words': [
     {'word': 'e-mail', 'stem': 'email'},
     {'word': 'javascript', 'stem': 'jquery'},
     {'word': 'javascript', 'stem': 'js'}
]};


// Related searches

var tipuesearch_related = {'searches': [
     {'search': 'tipue', 'related': 'Tipue Search'},
     {'search': 'tipue', 'before': 'Tipue Search', 'related': 'Getting Started'},
     {'search': 'tipue', 'before': 'Tipue', 'related': 'jQuery'},
     {'search': 'tipue', 'before': 'Tipue', 'related': 'Blog'}
]};


// Internal strings

var tipuesearch_string_1 = 'Brez naslova';
var tipuesearch_string_2 = 'Pokaži rezultate za';
var tipuesearch_string_3 = 'Išči namesto';
var tipuesearch_string_4 = '1 zadetek';
var tipuesearch_string_5 = 'zadetki';
var tipuesearch_string_6 = 'Nazaj';
var tipuesearch_string_7 = 'Naprej';
var tipuesearch_string_8 = 'Ničesar ne najdem.';
var tipuesearch_string_9 = 'Common words are largely ignored.';
var tipuesearch_string_10 = 'Iskalni niz je prekratek';
var tipuesearch_string_11 = 'Mora biti en znak ali več.';
var tipuesearch_string_12 = 'Morajo biti';
var tipuesearch_string_13 = 'znaki ali več.';
var tipuesearch_string_14 = 'sekund';
var tipuesearch_string_15 = 'Iskanje v povezavi z';


// Internals


// Timer for showTime

var startTimer = new Date().getTime();

