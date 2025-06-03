# Description
The name Greedypig comes from the fact that the player is canonically a pig that is willing to risk their lives for marginal profit gains. This game was inspired by casino games like roulette and poker, where gamblers bet money in the hopes of turning a profit.

Greedypig consists of 10 matches. Each match has a quota, which is reached through wagers. Wagers are fixed amounts of money that have a set chance of succeeding (i.e $5 wager might have a 35% of being successful). The player must weigh out the pros and cons of the three wager options given every match, assessing a wager’s output to its success. In a given match, the player can make a set amount of wagers, as many as 25 or as little as 1, depending on the match. If a player falls short of the quota, they must pay the difference out of pocket. If they exceed the quota, the difference is added to their bank. The bank carries through rounds.

To win at the game, the player must not be in debt after all the matches. The player starts with $100, and either gains or loses money after every match, although the rate of gains to losses varies among matches and playthroughs. 

The logic behind the game is very simple. Every time the player chooses from one of the available wager options, the dealer also chooses from the same set of wagers, based on a probability table. If both the player and the dealer pick the same thing, the player gets nothing. If the dealer picks something different to the player, the player earns that wager. This process repeats for as many turns as there are in a given match, with successful wagers being added to the quota while unsuccessful wagers are not.

There aren’t any rules per say, as this is a video game–made in godot, so the player is forced to adhere to the way the game works. The ‘rules’ would be to select wagers and not go in debt. 

# Functionality
## trials_hud.gd 
This is the script file that contains the relevant code for the trials system. 
Key functions include:

- _simulate_trials() 
- _calc_theoretical_trials()
- distributeSliderA()
- distributeSliderB()
- distributeSliderC()

## roulette_hud.gd
This is the script file that contains the relevant code for the roulette system.
Key functions include:

- _run_1000_trials()

## main.gd
This is the script file that contains the relevant code for the main game.
Key functions & data arrays include:

- _random_weighted()
- gameDict

## Overview
The meat and potatoes of the code is found within the trials hud script, more specifically within the theoretical calculation function. For more information on how that system was implimented, refer to the 'Greedypig Analysis' google document attached in the dropbox, or read a more brief analysis below.

## Theoretical calculation implimentation

For this calculation Match 6 will be used as an example, because it has exactly 10 turns which is nice to use. Think of it like this. Every turn has two states, failed or succeeded. So the total amount of combinations can be thought of as 2^10, or 2 x 2 x 2 x 2 x 2 x 2 x 2 x 2 x 2 x 2. This equates to 1024, which if you haven’t noticed by now, is binary. See, there’s a quirk about the way binary is stored, and that’s as a string combination of ones and zeros. Failures and successes. To count up to a number like 1024, binary must first go through every combination of 0’s and 1’s leading up to that, which just so happens to be perfectly aligned with the number of combinations that 10 wagers can result in. 

So the strategy is simple. First calculate the total number of wager outcomes, which can be defined as 2^n, where n represents the number of wagers. With this number in hand, start at 0, and increment one by one until you reach 1024. And for every increment, convert the base 10 number into its binary counterpart. Binary strings that are less than 10 characters long will automatically have the empty slots be 0’s. This would look something like this:

| Base 10       | Bit           |
| ------------- | ------------- |
| 0             | 0000000000    |
| 1             | 1000000000    |
| 2             | 0100000000    |
| 3             | 1100000000    |
| 4             | 0010000000    |
| 5             | 1010000000    |
| 6             | 0110000000    |


What’s fantastic about this is the string of ones and zeroes can be translated into success and failures, it’s even pre-indexed! So if we have a list of wagers like [13, 13, 13, 13, 14, 14, 14, 90, 90, 90], we can correlate the index in the wager array directly to the index in the bit string. If it’s a 1 in the bit string, then the equivalent wager index is successful and we should add it to the sum. If the string’s indexed bit is 0, then its corresponding wager index should also be 0, (not added). Because each wager has a different probability involved, we can ALSO index the probability array to the bit string, and use that probability as a weight. So successful wagers (where its corresponding bit string index is 1) would add to the quota sum and be multiplied to the probability weight, (which starts at 1), while unsuccessful wagers (where its corresponding bit string index is 0) will not be summed to the quota, but will still have its probability (but inversed) applied to the probability weight. Then, once all the 10 wager’s values (whether successful or not) are added up, a quota comparison check can be run. If the sum of the 10 wagers is equal to, or exceeds the quota, then its probability weights get added to a global numerator & denominator value that will eventually represent the theoretical probability of a selected set of wagers beating the quota. If it falls short of quota, it will only be added to the denominator. Rinse and repeat 2^n times (until 1024 in this case), and you’ve gone through every single wager outcome without having to do anything fancy. Well, unless you use bit shifting like I did, which is more optimized but really hard to understand (I don’t get it). Same idea though.


