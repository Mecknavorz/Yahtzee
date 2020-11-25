%-------------------------------
% Yahtzee//Yacht dice prolog AI
% made by: T&R, @mecknavorz
%-------------------------------

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
	
%play the game a number of times
play(N) :-		%Used to play the game N times
	M is N-1,	%since we stop at 0, remove one to make sure we don't do N+1 runs
	playr(M).	%actually play now
playr(0) :-				%this is out base case, when N finall reaches 0
	newHand(Hand),			%draw a new hand
	write("dice rolled are: "),	%print out the hand
	write(Hand), nl.
playr(N) :-				%the recursive function to play the game
	N>0,				%make sure we're still in the clear
	M is N-1,			%incriment the tracking variable
	newHand(Hand),			%drawa a new hand
	write("dice rolled are: "),	%print the hand
	write(Hand), write("	"),
	playr(M).			%keep playing for N-1 games.
