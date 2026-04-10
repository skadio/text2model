% Parameters (with values embedded)
int: max_total_tourists = 50;
int: cost_X = 150;
int: cost_Y = 200;
int: cost_Z = 100;

int: min_efficiency = 60;

% Variables
var 0..max_total_tourists: X;
var 0..max_total_tourists: Y;
var 0..max_total_tourists: Z;

var 0..(cost_X*max_total_tourists + cost_Y*max_total_tourists + cost_Z*max_total_tourists): total_cost;

% Constraints
constraint X + Y + Z <= max_total_tourists;

constraint 2*X + 3*Y + Z >= min_efficiency;

constraint abs(Y - Z) <= 10;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;