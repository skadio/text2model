% Parameters
int: min_total_props = 50;
int: max_combo = 120;                 % 2*X + Y <= 120
int: balance_min = 10;                % X - 3*Y >= 10
int: min_X = 20;
int: min_Y = 10;
int: cost_X = 5000;
int: cost_Y = 3000;

% Variables
var min_X..max_combo: X;              % residential properties (bounded by 2*X+Y<=120 and Y>=10)
var min_Y..max_combo: Y;              % commercial properties

var int: total_cost;

% Constraints
constraint X + Y >= min_total_props;
constraint 2*X + Y <= max_combo;
constraint X - 3*Y >= balance_min;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;