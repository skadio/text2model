% Parameters
int: total_budget_limit = 1000;                 % Maximum combined budget for departments X and Y
int: min_effectiveness = 500;                   % Minimum required effectiveness score
int: max_budget_difference = 300;               % Maximum allowed absolute difference between budgets

int: effectiveness_per_dollar_x = 2;            % Effectiveness contribution per $ for X
int: effectiveness_per_dollar_y = 1;            % Effectiveness contribution per $ for Y

int: cost_per_dollar_x = 5;                     % Cost per $ budget allocated to X
int: cost_per_dollar_y = 3;                     % Cost per $ budget allocated to Y

% Variables
var 0..total_budget_limit: budget_x;            % Budget allocated to department X (whole dollars)
var 0..total_budget_limit: budget_y;            % Budget allocated to department Y (whole dollars)

var 0..(cost_per_dollar_x*total_budget_limit + cost_per_dollar_y*total_budget_limit): total_cost;
                                                % Total cost (bounded)

var 0..(effectiveness_per_dollar_x*total_budget_limit + effectiveness_per_dollar_y*total_budget_limit): effectiveness;
                                                % Total effectiveness (bounded)

% Constraints
% Budget limit: combined budgets must not exceed the total budget cap
constraint budget_x + budget_y <= total_budget_limit;

% Effectiveness definition and minimum requirement
constraint effectiveness =
  effectiveness_per_dollar_x * budget_x + effectiveness_per_dollar_y * budget_y;
constraint effectiveness >= min_effectiveness;

% Fairness constraint: budgets for X and Y must not differ by more than the allowed amount
constraint abs(budget_x - budget_y) <= max_budget_difference;

% Total cost definition (objective minimizes this)
constraint total_cost = cost_per_dollar_x * budget_x + cost_per_dollar_y * budget_y;

% Objective
solve minimize total_cost;