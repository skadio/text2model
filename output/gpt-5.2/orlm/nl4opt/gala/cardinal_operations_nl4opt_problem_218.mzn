% Coin plating process planning (integer linear optimization)

include "globals.mzn";

% Data (embedded as requested)
int: gold_available = 500;
int: wires_available = 300;

int: goldA = 3;
int: wiresA = 2;
int: coinsA = 5;

int: goldB = 5;
int: wiresB = 3;
int: coinsB = 7;

% Decision variables: number of runs of each process (nonnegative integers)
var 0..max(gold_available div goldA, wires_available div wiresA): A;
var 0..max(gold_available div goldB, wires_available div wiresB): B;

% Resource constraints
constraint goldA * A + goldB * B <= gold_available;
constraint wiresA * A + wiresB * B <= wires_available;

% Objective: maximize total plated coins
var int: total_coins = coinsA * A + coinsB * B;

solve maximize total_coins;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "TotalCoins = ", show(total_coins), "\n",
  "GoldUsed = ", show(goldA*A + goldB*B), " / ", show(gold_available), "\n",
  "WiresUsed = ", show(wiresA*A + wiresB*B), " / ", show(wires_available), "\n"
];