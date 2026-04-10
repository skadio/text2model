% Parameters
int: total_budget_cap = 2000;
int: reach_rhs = 500;                  % 3*X1 - X2 >= 500
int: diff_cap = 800;                   % X1 - 2*X2 <= 800

int: cost_x1 = 1000;                   % dollars per unit investment
int: cost_x2 = 500;                    % dollars per unit investment

int: max_invest_x1_dollars = 1500;
int: max_invest_x2_dollars = 1000;

% Convert dollar caps to unit caps (investments are whole units)
int: max_units_x1 = max_invest_x1_dollars div cost_x1;  % 1
int: max_units_x2 = max_invest_x2_dollars div cost_x2;  % 2

% Variables
var 0..max_units_x1: x1_units;
var 0..max_units_x2: x2_units;

var int: total_cost;
var int: total_budget_used;

% Constraints
constraint total_cost = cost_x1 * x1_units + cost_x2 * x2_units;
constraint total_budget_used = x1_units + x2_units;

constraint total_budget_used <= total_budget_cap;

constraint 3 * x1_units - x2_units >= reach_rhs;
constraint x1_units - 2 * x2_units <= diff_cap;

% Objective
solve minimize total_cost;