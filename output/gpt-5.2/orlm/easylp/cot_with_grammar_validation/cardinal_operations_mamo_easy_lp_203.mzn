% Parameters
int: total_budget = 1000000;

int: min_X = 200000;
int: min_Y = 150000;
int: min_Z = 250000;

int: r_X_pct = 2;
int: r_Y_pct = 3;
int: r_Z_pct = 4;

% Variables
var min_X..total_budget: invest_X;
var min_Y..total_budget: invest_Y;
var min_Z..total_budget: invest_Z;

var 0..(total_budget * 4): total_return_dollars;

% Constraints
constraint invest_X + invest_Y + invest_Z = total_budget;

% Return in dollars (integer), computed exactly as percentage of dollars invested
constraint total_return_dollars =
  (r_X_pct * invest_X + r_Y_pct * invest_Y + r_Z_pct * invest_Z) div 100;

% Objective
solve minimize total_return_dollars;