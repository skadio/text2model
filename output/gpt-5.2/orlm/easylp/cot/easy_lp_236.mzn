% Parameters (with values embedded)
int: cost_wheat = 20;
int: cost_corn = 30;
int: cost_soy = 10;

int: max_wheat_corn = 200;
int: min_rotation = 150;
int: max_diff_corn_soy = 100;

% Variables
var 0..200: wheat;      % acres of wheat
var 0..200: corn;       % acres of corn
var 0..200: soybeans;   % acres of soybeans

% Constraints
constraint wheat + corn <= max_wheat_corn;

constraint 2 * wheat + soybeans >= min_rotation;

constraint abs(corn - soybeans) <= max_diff_corn_soy;

% Objective
var int: total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soybeans;
solve minimize total_cost;