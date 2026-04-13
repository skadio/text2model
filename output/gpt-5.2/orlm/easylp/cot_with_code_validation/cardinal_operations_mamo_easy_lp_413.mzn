% Parameters
int: total_budget = 2000;
int: reach_rhs = 500;
int: diff_ub = 800;

int: cost_x1 = 1000;
int: cost_x2 = 500;

int: max_spend_x1 = 1500;
int: max_spend_x2 = 1000;

% Convert max spend limits to max integer investment units
int: max_units_x1 = max_spend_x1 div cost_x1; % = 1
int: max_units_x2 = max_spend_x2 div cost_x2; % = 2

% Upper bound on total cost for bounding objective variable
int: max_total_cost = max_spend_x1 + max_spend_x2;

% Variables
var 0..max_units_x1: x1_units;
var 0..max_units_x2: x2_units;

var 0..max_total_cost: total_cost;

% Constraints
constraint total_cost = cost_x1 * x1_units + cost_x2 * x2_units;

% Total budget constraint
constraint total_cost <= total_budget;

% Reach/frequency constraint: 3*X1 - X2 >= 500 (X1,X2 are dollars spent)
constraint 3 * (cost_x1 * x1_units) - (cost_x2 * x2_units) >= reach_rhs;

% Difference constraint: X1 - 2*X2 <= 800 (X1,X2 are dollars spent)
constraint (cost_x1 * x1_units) - 2 * (cost_x2 * x2_units) <= diff_ub;

% Objective
solve minimize total_cost;