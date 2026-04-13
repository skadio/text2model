% Parameters
int: max_total_budget = 300;          % Maximum combined investment allowed
int: min_invest_X = 80;               % Minimum investment required for project X
int: min_invest_Y = 60;               % Minimum investment required for project Y
int: min_invest_Z = 40;               % Minimum investment required for project Z

int: cost_per_unit_X = 50;            % Cost per unit invested in project X
int: cost_per_unit_Y = 70;            % Cost per unit invested in project Y
int: cost_per_unit_Z = 100;           % Cost per unit invested in project Z


% Variables
var min_invest_X..max_total_budget: invest_X;   % Integer investment in project X
var min_invest_Y..max_total_budget: invest_Y;   % Integer investment in project Y
var min_invest_Z..max_total_budget: invest_Z;   % Integer investment in project Z

var int: total_cost;                            % Total cost to be minimized


% Constraints
% --- Budget feasibility constraint ---
constraint
  invest_X + invest_Y + invest_Z <= max_total_budget;

% --- Minimum investment constraints (redundant with variable domains, kept for clarity) ---
constraint invest_X >= min_invest_X;
constraint invest_Y >= min_invest_Y;
constraint invest_Z >= min_invest_Z;

% --- Total cost definition constraint ---
constraint
  total_cost =
    cost_per_unit_X * invest_X +
    cost_per_unit_Y * invest_Y +
    cost_per_unit_Z * invest_Z;


% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "invest_X = ", show(invest_X), "\n",
  "invest_Y = ", show(invest_Y), "\n",
  "invest_Z = ", show(invest_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];