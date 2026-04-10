% Parameters (with values embedded)
int: max_total_budget = 5000;
int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: req_effectiveness = 10000;   % 5*X + 10*Y >= 10000
int: diff_XZ_limit = 1500;        % |X - Z| <= 1500

% Variables
var 0..max_total_budget: X;   % dollars allocated to department X
var 0..max_total_budget: Y;   % dollars allocated to department Y
var 0..max_total_budget: Z;   % dollars allocated to department Z

var 0..(costX*max_total_budget + costY*max_total_budget + costZ*max_total_budget): total_cost;

% Constraints
constraint X + Y + Z <= max_total_budget;

constraint 5 * X + 10 * Y >= req_effectiveness;

constraint abs(X - Z) <= diff_XZ_limit;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;