% Parameters
% Total combined budget limit (in dollars)
int: total_budget_limit = 2000;

% Reach/frequency constraint RHS (units)
int: reach_rhs = 500;

% Difference constraint upper bound (units)
int: diff_limit = 800;

% Cost per unit invested (in dollars)
int: cost_per_unit_x1 = 1000;
int: cost_per_unit_x2 = 500;

% Maximum allowable investment (in dollars)
int: max_invest_x1_dollars = 1500;
int: max_invest_x2_dollars = 1000;

% Derived integer upper bounds on whole-number investment units
% (Assumes decision variables count whole units; each unit costs as above)
int: max_units_x1 = max_invest_x1_dollars div cost_per_unit_x1;
int: max_units_x2 = max_invest_x2_dollars div cost_per_unit_x2;

% Variables
% Whole-number investment units in each campaign (nonnegative, bounded)
var 0..max_units_x1: x1_units;  % units invested in campaign X1
var 0..max_units_x2: x2_units;  % units invested in campaign X2

% Total cost in dollars (bounded for linearity and clarity)
var 0..(cost_per_unit_x1*max_units_x1 + cost_per_unit_x2*max_units_x2): total_cost;

% Constraints
% Link total_cost to the chosen whole-number investment units
constraint
  total_cost = cost_per_unit_x1 * x1_units + cost_per_unit_x2 * x2_units;

% Total combined budget limit (in dollars)
constraint
  cost_per_unit_x1 * x1_units + cost_per_unit_x2 * x2_units <= total_budget_limit;

% Reach/frequency requirement: 3*x1 - x2 >= reach_rhs
constraint
  3 * x1_units - x2_units >= reach_rhs;

% Difference constraint: x1 - 2*x2 <= diff_limit
constraint
  x1_units - 2 * x2_units <= diff_limit;

% Objective
solve minimize total_cost;