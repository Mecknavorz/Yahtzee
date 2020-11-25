# Yahtzee
###Yahtzee/Yacht dice playing AI made in prolog

## What does it do?
The end goal is to produce an AI to play the game yahtzee/yacht dice. There will be two ways to do this, one is with the command `play(N).` which will play N games by itself. The second mode will be slower, meant to be played with real dice giving the user the ability to input the dice into the game so that the AI could in theory play other people.

## What is currently implemented?
Currently Implementede features are:
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

## What features are planned?
Currently planned features/ones that are being worked on are:
- Hand detection to show the rank of a hand
- score caculation, to keep determie the actual point score of a hand
- game tracker, to keep track of hands filled out on a standard chart
- game AI, to take use the game tracker and make a probabilist decision tree based off that and play the game autonomously
- manual mode, so that dice and hands can be input manually
- rules, to switch on or off optional rules and essentially change the game between Yahtzee of yacht dice depending on what we want to see