% Parameters
int: treats_available = 200;
int: otter_tricks_per = 3;
int: otter_treats_per = 3;
int: dolphin_tricks_per = 1;
int: dolphin_treats_per = 5;
int: min_dolphins = 10;
int: otter_max_percent = 30;

% Variables
var 0..(treats_available div otter_treats_per): otters;
var min_dolphins..(treats_available div dolphin_treats_per): dolphins;

var 0..(otter_tricks_per*(treats_available div otter_treats_per) + dolphin_tricks_per*(treats_available div dolphin_treats_per)): total_tricks;

% Constraints
constraint otter_treats_per * otters + dolphin_treats_per * dolphins <= treats_available;

% At most 30% otters: otters <= 0.30*(otters+dolphins)
% Use integer linearization: 100*otters <= 30*(otters+dolphins)
constraint 100 * otters <= otter_max_percent * (otters + dolphins);

constraint total_tricks = otter_tricks_per * otters + dolphin_tricks_per * dolphins;

% Objective
solve maximize total_tricks;