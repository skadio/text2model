% Parameters
int: min_total_props = 50;
int: max_twice_res_plus_com = 120;
int: min_res_minus_3com = 10;

int: min_res = 20;
int: min_com = 10;

int: cost_res = 5000;
int: cost_com = 3000;

% Variables
var min_res..max_twice_res_plus_com: X; % residential units
var min_com..max_twice_res_plus_com: Y; % commercial units

var int: total_cost;

% Constraints
constraint X + Y >= min_total_props;
constraint 2 * X + Y <= max_twice_res_plus_com;
constraint X - 3 * Y >= min_res_minus_3com;

constraint total_cost = cost_res * X + cost_com * Y;

% Objective
solve minimize total_cost;