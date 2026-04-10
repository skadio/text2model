% Aquarium show optimization: maximize tricks given treat budget and popularity constraints.

include "globals.mzn";

% Data (embedded as required)
int: treat_budget = 200;

int: tricks_per_otter = 3;
int: treats_per_otter = 3;

int: tricks_per_dolphin = 1;
int: treats_per_dolphin = 5;

int: min_dolphins = 10;
float: max_otter_fraction = 0.30;

% Decision variables
var 0..treat_budget div treats_per_otter: otters;
var min_dolphins..treat_budget div treats_per_dolphin: dolphins;

% Resource constraint (treats)
constraint treats_per_otter * otters + treats_per_dolphin * dolphins <= treat_budget;

% Popularity constraint: at most 30% otters of total performers
% otters <= 0.30*(otters + dolphins)  <=>  7*otters <= 3*dolphins
constraint 7 * otters <= 3 * dolphins;

% Objective: maximize total tricks
var 0..10000: total_tricks = tricks_per_otter * otters + tricks_per_dolphin * dolphins;

solve maximize total_tricks;

output [
  "otters = ", show(otters), "\n",
  "dolphins = ", show(dolphins), "\n",
  "treats_used = ", show(treats_per_otter * otters + treats_per_dolphin * dolphins), " / ", show(treat_budget), "\n",
  "total_tricks = ", show(total_tricks), "\n"
];