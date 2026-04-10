% Parameters
int: land_limit = 500;
int: min_diverse = 200;          % 2*X + Y >= 200
int: yz_diff_limit = 50;         % |Y - Z| <= 50
int: x_z_relation_min = 100;     % X - Z >= 100 (since "twice half of Z" = Z)

int: cost_x = 100;
int: cost_y = 50;
int: cost_z = 75;

% Variables
var 0..land_limit: X;
var 0..land_limit: Y;
var 0..land_limit: Z;

var 0..(cost_x*land_limit + cost_y*land_limit + cost_z*land_limit): total_cost;

% Constraints
constraint X + Y + Z <= land_limit;

constraint 2 * X + Y >= min_diverse;

constraint abs(Y - Z) <= yz_diff_limit;

constraint X - Z >= x_z_relation_min;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;