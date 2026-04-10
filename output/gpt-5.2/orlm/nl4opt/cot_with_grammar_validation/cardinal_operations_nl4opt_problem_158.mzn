% Parameters
int: treats_available = 200;

int: tricks_per_otter = 3;
int: treats_per_otter = 3;

int: tricks_per_dolphin = 1;
int: treats_per_dolphin = 5;

int: min_dolphins = 10;

% Variables
var 0..treats_available div treats_per_otter: otters;
var min_dolphins..treats_available div treats_per_dolphin: dolphins;

var 0..(tricks_per_otter * (treats_available div treats_per_otter) + tricks_per_dolphin * (treats_available div treats_per_dolphin)): total_tricks;

% Constraints
constraint treats_per_otter * otters + treats_per_dolphin * dolphins <= treats_available;

% At most 30% of performers can be otters: otters <= 0.3*(otters+dolphins)
% Use integer arithmetic to avoid floats: 10*otters <= 3*(otters+dolphins)
constraint 10 * otters <= 3 * (otters + dolphins);

constraint total_tricks = tricks_per_otter * otters + tricks_per_dolphin * dolphins;

% Objective
solve maximize total_tricks;