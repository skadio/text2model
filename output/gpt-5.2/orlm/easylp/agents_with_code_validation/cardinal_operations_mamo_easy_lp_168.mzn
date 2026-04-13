% Parameters
int: total_budget = 1000;              % Maximum total budget available

int: min_budget_X = 200;               % Minimum viable budget for channel X
int: min_budget_Y = 150;               % Minimum viable budget for channel Y
int: min_budget_Z = 100;               % Minimum viable budget for channel Z

int: cost_per_unit_X = 50;             % Cost per unit effectiveness for X
int: cost_per_unit_Y = 60;             % Cost per unit effectiveness for Y
int: cost_per_unit_Z = 70;             % Cost per unit effectiveness for Z


% Variables
% Budgets are whole dollars and must at least satisfy minimum requirements.
var min_budget_X..total_budget: budget_X;   % Budget allocated to channel X
var min_budget_Y..total_budget: budget_Y;   % Budget allocated to channel Y
var min_budget_Z..total_budget: budget_Z;   % Budget allocated to channel Z

% Total cost is integer dollars (unit costs and budgets are integers).
var 0..(cost_per_unit_X*total_budget + cost_per_unit_Y*total_budget + cost_per_unit_Z*total_budget): total_cost;


% Constraints
% --- Total budget cap: combined allocation cannot exceed the available total budget ---
constraint budget_X + budget_Y + budget_Z <= total_budget;

% --- Total cost definition: sum of per-channel unit costs times allocated budgets ---
constraint
  total_cost =
    cost_per_unit_X * budget_X +
    cost_per_unit_Y * budget_Y +
    cost_per_unit_Z * budget_Z;


% Objective
solve minimize total_cost;

output [
  "budget_X = ", show(budget_X), "\n",
  "budget_Y = ", show(budget_Y), "\n",
  "budget_Z = ", show(budget_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];