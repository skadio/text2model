% Parameters
% Total available budget for both campaigns (in dollars)
int: total_budget = 2000;

% Reach/frequency constraint threshold (units)
int: reach_rhs = 500;

% Difference constraint upper bound (units)
int: diff_ub = 800;

% Cost per investment unit for each campaign (in dollars)
int: cost_x1 = 1000;
int: cost_x2 = 500;

% Maximum allowable investment (in dollars) in each campaign
int: max_invest_x1 = 1500;
int: max_invest_x2 = 1000;

% Derived bounds on number of whole investment units (since investments are indivisible)
int: max_units_x1 = max_invest_x1 div cost_x1; % = 1
int: max_units_x2 = max_invest_x2 div cost_x2; % = 2


% Variables
% Number of whole investment units allocated to campaign X1 and X2
var 0..max_units_x1: x1_units;
var 0..max_units_x2: x2_units;

% Total cost (in dollars)
var 0..total_budget: total_cost;


% Constraints
% Link decision variables to total cost (in dollars)
constraint
  total_cost = cost_x1 * x1_units + cost_x2 * x2_units;

% Total combined budget cannot exceed the available total budget
constraint
  total_cost <= total_budget;

% Reach/frequency requirement: 3*x1_units - x2_units >= reach_rhs
constraint
  3 * x1_units - x2_units >= reach_rhs;

% Difference constraint: x1_units - 2*x2_units should not exceed diff_ub
constraint
  x1_units - 2 * x2_units <= diff_ub;


% Objective
solve minimize total_cost;