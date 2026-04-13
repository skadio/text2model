% Parameters
int: otter_tricks = 3;
int: otter_treats = 3;
int: dolphin_tricks = 1;
int: dolphin_treats = 5;

int: min_dolphins = 10;
int: max_otter_percent = 30; % percent
int: total_treats = 200;

% Variables
var 0..(total_treats div otter_treats): otters;
var 0..(total_treats div dolphin_treats): dolphins;

% Constraints
constraint otter_treats * otters + dolphin_treats * dolphins <= total_treats;
constraint dolphins >= min_dolphins;

% at most 30% of performers can be otters: otters <= 0.30 * (otters + dolphins)
% avoid floats: 100*otters <= 30*(otters + dolphins)
constraint 100 * otters <= max_otter_percent * (otters + dolphins);

% Objective
solve maximize otter_tricks * otters + dolphin_tricks * dolphins;