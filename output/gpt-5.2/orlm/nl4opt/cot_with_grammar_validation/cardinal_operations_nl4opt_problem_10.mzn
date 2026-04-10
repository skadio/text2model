% Parameters
int: pigeon_capacity = 2;
int: pigeon_treats = 3;

int: owl_capacity = 5;
int: owl_treats = 5;

int: total_treats = 1000;
int: min_pigeons = 20;

int: owl_share_num = 40; % at most 40% owls
int: owl_share_den = 100;

% Upper bounds from treats (and min pigeons)
int: max_pigeons = total_treats div pigeon_treats; % 333
int: max_owls = total_treats div owl_treats;       % 200

% Variables
var min_pigeons..max_pigeons: pigeons;
var 0..max_owls: owls;

% Constraints
constraint pigeon_treats * pigeons + owl_treats * owls <= total_treats;

% At most 40% of birds can be owls: owls <= 0.4*(pigeons+owls)
% Use integer form: 100*owls <= 40*(pigeons+owls)  <=> 60*owls <= 40*pigeons
constraint (owl_share_den - owl_share_num) * owls <= owl_share_num * pigeons;

% Objective
solve maximize pigeon_capacity * pigeons + owl_capacity * owls;