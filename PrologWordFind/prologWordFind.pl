%% % Word Find Generator

%% A word find is a game using a rectangular block of text.  A list words
%% are hidden in the text and user attempts to identify them.  The same
%% letters might be used in multiple words.

%% For example, this word find contains the words ninja and note:

%% abcde
%% ninja
%% qzomn
%% qqtqq
%% yzexx

%% In small word finds that have many words, often there are only a few
%% ways the words can be positioned so they can all fit.

%% We'll use prolog to find all possible word positions.

%% Step A: Read section 4.4 of your textbook
%% Step B: (15 points):

%% Write a function make_word_find_linear(Words,Size,Result).
%% This function takes a list of words and positions them on
%% a single line of the given length.  For places that are not
%% needed, the function should have ?.  For example:

%% ?- make_word_find_linear(['love','hello'],10,X).
%% X = "lovehello?" ;
%% X = "love?hello" ;
%% X = "?lovehello" ;
%% X = "hellove???" ;
%% X = "?hellove??" ;
%% X = "hellolove?" ;
%% X = "??hellove?" ;
%% X = "hello?love" ;
%% X = "?hellolove" ;
%% X = "???hellove" ;
%% false.

%% One complication will be prologs strange way of representing
%% strings.  There are 2: single quoted 'strings' that print out
%% nicely and double quoted strings that are actually lists.
%% For example:

%% ?- X="test",Y='test'.
%% X = [116, 101, 115, 116],
%% Y = test.

%% Lists are what you'll want for actually doing computation but
%% for the input/output you'll want to use the single quoted ones.
%% Luckly you can convert using the string_codes function:

%% ?- string_codes(X,[116, 101, 115, 116]).
%% X = "test".

%% But this won't work if one of the items in the list is unbound.  In
%% that case, use this handy listBind function I wrote.  It's used to
%% take a list of numbers, and bind any unbound
%% variables to 63 (character value of ?).  Do this before
%% you attempt to use to convert a "string" into a 'string':

%% ?- X = [104,105,_,_,_], listBind(X), string_codes(Y,X).
%% X = [104, 105, 63, 63, 63],
%% Y = "hi???".


listBind([63|T]) :- listBind(T), !. % the "!" is known as a cut
listBind([_|T]) :- listBind(T).
listBind([]).

% make_word_find_linear(Words,Size,Result) :-
% YOUR COOL CODE HERE (you'll need helper functions)

make_word_find_linear(Words,Size,Result) :- 
  helper(Words,Size,Temp), 
  listBind(Temp), 
  string_codes(Result,Temp).

helper([],Size,Result) :- length(Result,Size).
helper([First|Rest],Size,Result) :- 
  length(Result,Size),
  string_codes(First,FirstList),
  sublist(FirstList,Result),
  helper(Rest,Size,Result).

sublist([],_).
sublist(X,[Y|YS]) :- prefix(X,[Y|YS]).
sublist(X,[_|YS]) :- sublist(X,YS).

prefix([],_).
prefix([A|XS],[A|YS]) :- prefix(XS,YS).


%% Step C: 15 Points

%% now make a version that makes a rectangle of text
%% it has a width and height, but words will still be stored only
%% horizontally.  For example:

%% ?- make_word_find_rect(['ah','ham'],4,2,X).
%% X = ["aham", "????"] ;
%% X = ["ah??", "ham?"] ;
%% X = ["ah??", "?ham"] ;
%% X = ["?ah?", "ham?"] ;
%% X = ["?ah?", "?ham"] ;
%% X = ["??ah", "ham?"] ;
%% X = ["??ah", "?ham"] ;
%% X = ["ham?", "ah??"] ;
%% X = ["ham?", "?ah?"] ;
%% X = ["ham?", "??ah"] ;
%% X = ["?ham", "ah??"] ;
%% X = ["?ham", "?ah?"] ;
%% X = ["?ham", "??ah"] ;
%% X = ["????", "aham"] ;
%% false.

% make_word_find_rect(Words,Width,Height,StringResults) :-
% YOUR COOL CODE HERE (you'll need helper functions)

make_word_find_rect(Words,Width,Height,StringResults) :-
  Height > 0,
  length(StringResults,Height),
  partition(Words,Height,WordSets),
  to_rect_string(WordSets,Width,StringResults).

to_rect_string([],_,[]).
to_rect_string([H1|T1],Width,[H2|T2]) :- 
  make_word_find_linear(H1,Width,H2),
  to_rect_string(T1,Width,T2).

partition(Words,1,[Words]).
partition(Words,NumBuckets,Buckets) :-
  permutation(Words,ScrambledWords),
  length(Buckets,NumBuckets),
  append(Buckets,ScrambledWords),
  inner_lists_sorted(Buckets).

% removes redundant answers
inner_lists_sorted([]).
inner_lists_sorted([FirstList|OtherLists]) :-
  sort(FirstList,FirstList),
  inner_lists_sorted(OtherLists).


%% Step D 5 points: This last step is not worth too many
%% points, so feel free to stop if you aren't enjoying
%% yourself.

%% The final goal is to use both vertical and horzontal
%% words.  for example:

%% ?- make_word_find_rect_v(['hi','ho'],2,2,X).
%% X = ["hi", "ho"] ;
%% X = ["ho", "hi"] ;
%% X = ["hi", "o?"] ;
%% X = ["ho", "i?"] ;
%% X = ["hh", "io"] ;
%% X = ["hh", "oi"] ;
%% false.

%% Hint: I solved this one by write a function that took my
%% 2d array of bound/unbound letters and writing a function
%% that exchanged rows and columns.  Then I just reused
%% make_word_find_rect on the 'rotated' array.

% make_word_find_rect_v(Words,Width,Height,StringResults) :-
% YOUR COOL CODE HERE (plus helper functions)

make_word_find_rect_v(Words,Width,Height,StringResults) :-
  partition(Words,2,[Horizontal|[Vertical]]),
  make_word_find_rect(Horizontal,Width,Height,HResults),
  make_word_find_rect(Vertical,Height,Width,VResults),
  maplist(string_codes,VResults,Flipped),
  maplist(string_codes,HResults,HCodes),
  transpose(Flipped,VCodes),
  merge(HCodes,VCodes,Codes),
  maplist(listBind,Codes),
  maplist(string_codes,StringResults,Codes).


merge([],[],[]).
merge([H1|T1],[H2|T2],[H3|T3]) :-
  maplist(merge_letters,H1,H2,H3),
  merge(T1,T2,T3).

merge_letters(A,B,C) :- A = B, B = C.
merge_letters(A,B,C) :- A = 63, B = C, C \= 63.
merge_letters(A,B,C) :- A = C, B = 63, C \= 63.

cdr([_|T],T).
my_length(A,B) :- length(B,A).
transpose([],_).
transpose([H|T],A) :-
  maplist(nth1(1),A,H),
  maplist(cdr,A,B),
  transpose(T,B),
  length([H|T],L),
  maplist(my_length(L),A).
