% Parameters (with values embedded)
int: total_budget_max = 5000;

int: min_invest_X = 1000;
int: max_invest_Y = 3000;
int: min_invest_Z = 500;

int: cost_per_unit_X = 100;
int: cost_per_unit_Y = 200;
int: cost_per_unit_Z = 50;

% Variables
var 0..total_budget_max: invest_X;
var 0..total_budget_max: invest_Y;
var 0..total_budget_max: invest_Z;

var 0..(cost_per_unit_X*total_budget_max + cost_per_unit_Y*total_budget_max + cost_per_unit_Z*total_budget_max): total_cost;

% Constraints
constraint invest_X + invest_Y + invest_Z <= total_budget_max;

constraint invest_X >= min_invest_X;
constraint invest_Y <= max_invest_Y;
constraint invest_Z >= min_invest_Z;

constraint total_cost = cost_per_unit_X*invest_X + cost_per_unit_Y*invest_Y + cost_per_unit_Z*invest_Z;

% Objective
solve minimize total_cost;