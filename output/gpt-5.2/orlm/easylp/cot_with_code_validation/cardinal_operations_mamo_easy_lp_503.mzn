% Parameters
int: total_budget = 1000;

int: X_lb = 0;
int: X_ub = 500;

int: Y_lb = 0;
int: Y_ub = 400;

int: Z_lb = 0;
int: Z_ub = 600;

int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 300;

int: diff_limit = 150;
int: Y_minus_Z_min = 50;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..(cost_X*X_ub + cost_Y*Y_ub + cost_Z*Z_ub): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint 2 * X >= Y;

constraint abs(4 * Z - 3 * X) <= 600; % 4 * 150 to avoid fractions in |Z - 3/4 X| <= 150

constraint Y >= Z + Y_minus_Z_min;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;