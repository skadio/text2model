% Parameters (with values embedded)
int: treats_available = 200;

int: otter_tricks = 3;
int: otter_treats = 3;

int: dolphin_tricks = 1;
int: dolphin_treats = 5;

int: min_dolphins = 10;

% Variables
var 0..treats_available div otter_treats: O; % number of otters
var min_dolphins..treats_available div dolphin_treats: D; % number of dolphins

var 0..(treats_available div otter_treats) * otter_tricks + (treats_available div dolphin_treats) * dolphin_tricks: total_tricks;

% Constraints
constraint otter_treats * O + dolphin_treats * D <= treats_available;

% At most 30% of performers can be otters: O/(O+D) <= 0.3  ->  10*O <= 3*(O+D)
constraint 10 * O <= 3 * (O + D);

constraint total_tricks = otter_tricks * O + dolphin_tricks * D;

% Objective
solve maximize total_tricks;