# Yahtzee
### Yahtzee/Yacht dice playing AI made in prolog

## What does it do?
The end goal is to produce an AI to play the game Yahtzee/yacht dice. There will be two ways to do this, one is with the command `play(N).` which will play N games by itself. The second mode will be slower, meant to be played with real dice giving the user the ability to input the dice into the game so that the AI could in theory play other people.

## What is currently implemented?
Currently implemented features are:
- `play(N).` play the game N number of times
- `roll(Dice).` which rolls a single die
- `newHand(Hand).` which generates a new set of 5 dice, a hand of Yahtzee
- `discard(Discard, Hand, Out).` where:
   - Discard is a list of dice you want to discard
   - Hand is the current hand
   - Out is the new hand
- `draw(Hand, FHand).` where:
   - Hand is the current hand, which has less than 5 dice
   - Fhand is the new hand with a full five dice again
- `determine(Hand, Type).` determines if a hand is a given type, e.g. yahzee, small straight etc., and returns that type
- A few types of score functions for different hands
   - `score(Type, Score).` which works for: Yahtzee, large straight, small straight an full house
   - `score(Type, Hand, Score).` which works for: three and four of a kind as well as chance
   - `score(free, Val, Hand, Score).` which is used for the upper card section, e.g. ones, twos threes, etc. where Val is the type of die you want to score for
- `newSheet(Sheet)` which generates a blank score sheet, all indices are initialized at -1 since 0 is a valid score and we want to know what's been used
- `storeScore(Sheet, Type, Score, NSheet).` which updates the sheet to have a score of `Score` for the `Type` space
- `getScore(Sheet, Type, NSheet).` has two versions because I haven't decided which I like more
   - One takes Type as an index value (int) of the score sheet list and returns the score at that index
   - The second (which is commented out by default) takes Type as the actually hand type and converts it to an index value an returns the score there
- `toRemove(Hand, Sheet, Goal, Toss)` tells you which dice to `Toss` from `Hand` to give you the best chance at getting to `Goal`. The reason it also takes the `Sheet` is that some hands require a knowledge of what the current dice sheet looks like in order to determine the best dice to `Toss` to get to `Goal`
   - this function contains a bunch of sub functions: `smax/3`, `fhmax/2`, and `lomax/3` which each optimize for different parts of the lower card.

## What features are planned?
Currently planned features/ones that are being worked on are:
- game AI, to take use the game tracker and make a probabilistic decision tree based off that and play the game autonomously
- manual mode, so that dice and hands can be input manually
- rules, to switch on or off optional rules and essentially change the game between Yahtzee of yacht dice depending on what we want to see
