%-------------------------------------------------------------------------------------------
%Yahtzee//Yacth dice prolog AI
%made by: T&R, @mecknavorz
%I tried to losely organize all the functions based on what role they play in an AI model
%eg: Environment, Actuators, Sensors, Agent, and then just the Play commands to get it going
%-------------------------------------------------------------------------------------------

%-------------------------------------------------------------------------------------------------------------
%ENVIRONMENT STUFF
%This is all the game rules that we'll need to describe a game of Yahtzee//Yacht dice that aren't also actions
%namely the score card and what type of hand goes into what slot
%-------------------------------------------------------------------------------------------------------------
%used to easly convert a type of hand into where it needs to be stored in the array
slot(aces, 0).
slot(two, 1).
slot(threes, 2).
slot(fours, 3).
slot(fives, 4).
slot(sixes, 5).
slot(bonus, 6).
slot(three_of_a_kind, 7).
slot(four_of_a_kind, 8).
slot(full_house, 9).
slot(small_straight, 10).
slot(large_straight, 11).
slot(yahtzee, 12).
slot(chance, 13).
slot(yahtzee_bonus, 14).

%make a new score sheet and save it to Sheet
newSheet(Sheet) :-
	newSheet(14, Sheet).	%since a yahtzee sheet will always have 14 slots, initilaze newSheet with a constant
newSheet(-1, []) :- !. 		%base case for our new sheet creation
newSheet(N, [-1|M]) :-		%recusrive function that sets all values of our sheet to -1, since 0 is a possibility
	Nn is N-1,		%subtract one from the remaining count so we don't make an infite list
	newSheet(Nn, M).	%recursive call

%store a score in the array
storeScore(Sheet, Slot, Score, NSheet) :-
	slot(Slot, S),			%get the index value of the given slot
	nth0(S, Sheet, _, Temp),	%get an array without that given index
	nth0(S, NSheet, Score, Temp).	%place the new value in the index and return the new array

%access the current score stored in the array
getScore(Sheet, Slot, NSheet) :-	%get the score by using the index value
	nth0(Slot, Sheet, NSheet).
%getScore(Sheet, Slot, NSheet) :-	%get the score by using the slot name
	%slot(Slot, S),			%get the index of the slot
	%nth0(S, Sheet, NSheet).	%return the score

%-----------------------------------------------------------------------------
%BASIC ACTUATORS
%eg how we manipulate the game space
%Specifically: roll, get a new hand, dicard and redraw dice, as well as a sort
%-----------------------------------------------------------------------------
%roll a die
roll(Dice) :-
	random(1, 7, Dice).

%get a new hand of dice
newHand(Hand) :-
	roll(D1),
	roll(D2),
	roll(D3),
	roll(D4),
	roll(D5),
	append([D1,D2,D3,D4,D5], [], Hand).
	
%discard a number of dice based on their value
discard([], X, X). 			%this is the base case, it just returns the hand when the discard is empty
discard([H|T], Hand, Out) :-
	remove(H, Hand, Temp), 		%remove the fist discard die from our hand
	discard(T, Temp, Out). 		%remove the rest of the discard from out hand via recusion.
	
%used to delte only the first instance of a number in the discard commands
remove(X,[X|Xs],Xs).			%base case for the remove function
remove(X,[Y|Xs],[Y|Ys]) :- 
    X \= Y,
    remove(X,Xs,Ys).

%replenish the hand after a discard, will draw back upto 5.
draw([], FHand) :- newHand(FHand). 	%if we're given an empty hand, just make a whole new one
draw(Hand, FHand) :- 			%Hand is the old hand, FHand is the new hand, this is what we'll call on to replenish a hand
	length(Hand, N), 		%get the lngth of the old hand
	M is 5-N, 			%from there figure out how many times we need to run
	draw(M, Hand, FHand). 		%Fill out the hand recursively
draw(0, X, X). 				%this is our base case for the recursive function
draw(N, Hand, FHand) :-			%this is our normal function
	N<5,				%make sure we're not overfilling
	M is N-1,			%incriment the tracking variable
	roll(D1),			%roll a new die
	append(Hand, [D1], Temp),	%add that die to the hand
	draw(M, Temp, FHand).		%Fill out the hand recursively

%diceSort used to sort hands so tht it's easier to do operations on em
%I thought I would have to write a whole thing for this but there's a built in sort so I might not need this
diceSort(Hand, SHand):- %since we always need to sort in the same way might as well simplify it a bit
	sort(0, @=<, Hand, SHand).


%-------------------------------------------------------------------------------------------------------------
%MOSTLY SENSOR STUFF
%Namley: determine the type of hand, and determine the score
%the score determination is also partly an actuator, but it fit better here since it provides feedback as well
%-------------------------------------------------------------------------------------------------------------
%determine the type of hand, if any is present
determine([X,X,X,X,X], yahtzee).	%if all dice in the hand are the same it's a yahtzee!
%the small striaght code (and to a lesser  degree the large straight code) was super duper fucking jank to make
%could not have done it without @thundergonian and @linear_mderg
determine([A,B,C,D,E], large_straight) :-
    E is (D + 1), D is (C + 1), C is (B + 1), B is (A + 1). %a large striaght is basically just a singular increasing sequence
determine([A|L], small_straight) :-		%first we need to check if a seuqnece of A,A+1,A+2,A+3 exists in our hand
    P is A+1, Q is A+2, R is A+3,		%establish the vars in the sequence
    subset([A, P, Q, R], [A|L]).		%if out sequence is a subset of the hand then there is a small straight
determine([A|[B|L]], small_straight) :-		%if not then we check if a seuqnece of B,B+1,B+2,B+3 exists in our hand
    P is B+1, Q is B+2, R is B+3,		%establish the vars in the sequence
    subset([B, P, Q, R], [A|[B|L]]).		%if out sequence is a subset of the hand then there is a small straight
determine([A,B,C,D,E], full_house) :-
	A = B, D = E, (C = D; C = B).		%for a full house the values on the edges will always be the same as the ones nexto em and the middle varies
determine([A,X,X,X,E], four_of_a_kind) :-
	A = X; E = X.				%the middle 3 will always equal each other and the outer ones will vary
determine([A,B,C,D,E], three_of_a_kind) :- 	%some versions don't have this so I need to find a way to toggle it
	(A=B, B=C); (B=C, C=D); (C=D, D=E).	%thee of a kind of three of the viarables are the same
determine([_,_,_,_,_], free). 			%this is used when there's not a explicitly defined score to the hand

%score function gives the point value of a given hands
score(yahtzee, 50).					%for normal Yahtzee a Yahtzee is worth 50 points
score(large_straight, 40).				%for normal Yahtzee large straight is worth 40 points
score(small_straight, 30).				%for normal Yahtzee small striaght is worth 30 points
score(full_house, 25).					%for normal Yahtzee full house is worth 25 points
score(four_of_a_kind, Hand, Score) :-	%for normal Yahtzee four of a kind is worth the sum of the hand
	sumlist(Hand, Score).
score(three_of_a_kind, Hand, Score) :-	%for normal Yahtzee three of a kind is worth the sum of the hand
	sumlist(Hand, Score).
score(chance, Hand, Score) :-		%Chance is worth the sum of the dice in the hand
	sumlist(Hand, Score).
score(free, Val, Hand, Score) :-	%for the uppercard we need to determine the # of val in the hand and sum it up
	count(Val, Hand, Base),
	Score is Val*Base.

%used to count the number of occurences in an array
%used specfically in the free score calculation
%count the number of times X shows up in array an output it to N
count(_, [], 0).	%base case of count, return 0 for an empty list
count(X, [X|T], N) :-	%if the head is X
  !, count(X, T, N1),	
  N is N1 + 1.		%increase the count
count(X, [_|T], N) :-
  count(X, T, N).	%if the head isn't X then just keep searching

	
%-------------------------------
%PLAY THE GAME AUTOMATICALLY
%-------------------------------
play(N) :-		%Used to play the game N times
	M is N-1,	%since we stop at 0, remove one to make sure we don't do N+1 runs
	playr(M).	%actually play now
playr(0) :-				%this is out base case, when N finall reaches 0
	newHand(Hand),			%draw a new hand
	write("dice rolled are: "),	%print out the hand
	write(Hand), nl,
	diceSort(Hand, FHand),
	determine(FHand, Rank),
	write("current hand is a: "),
	write(Rank), nl.
playr(N) :-				%the recursive function to play the game
	N>0,				%make sure we're still in the clear
	M is N-1,			%incriment the tracking variable
	newHand(Hand),			%drawa a new hand
	write("dice rolled are: "),	%print the hand
	write(Hand), nl,
	diceSort(Hand, FHand),
	determine(FHand, Rank),
	write("current hand is a: "),
	write(Rank), nl,
	playr(M).			%keep playing for N-1 games.
