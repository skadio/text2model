% Parameters
int: min_effectiveness = 50;          % Minimum required effectiveness score (Ad1 + Ad2)
int: fatigue_coef_ad1 = 4;            % Fatigue coefficient for Ad1
int: fatigue_coef_ad2 = 6;            % Fatigue coefficient for Ad2
int: max_fatigue = 300;               % Maximum allowed combined fatigue score
int: cost_per_unit_ad1 = 5;           % Cost per unit (dollar) for Ad1
int: cost_per_unit_ad2 = 3;           % Cost per unit (dollar) for Ad2

% Safe upper bound for budgets from fatigue constraint:
% 4*Ad1 + 6*Ad2 <= 300 implies Ad1 <= 75 and Ad2 <= 50; use a common upper bound.
int: max_budget = 75;                 % Upper bound for Ad1 and Ad2 budgets

% Variables
var 0..max_budget: budget_ad1;        % Budget allocated to Ad1 (integer dollars)
var 0..max_budget: budget_ad2;        % Budget allocated to Ad2 (integer dollars)

var 0..(cost_per_unit_ad1*max_budget + cost_per_unit_ad2*max_budget): total_cost;
                                      % Total cost to minimize

% Derived measures for clarity
var 0..(2*max_budget): effectiveness; % Effectiveness score = budget_ad1 + budget_ad2
var 0..max_fatigue: fatigue;          % Fatigue score = 4*budget_ad1 + 6*budget_ad2

% Constraints

% --- Define derived measures (effectiveness and fatigue) ---
constraint effectiveness = budget_ad1 + budget_ad2;

constraint fatigue = fatigue_coef_ad1 * budget_ad1 + fatigue_coef_ad2 * budget_ad2;

% --- Minimum effectiveness requirement ---
constraint effectiveness >= min_effectiveness;

% --- Audience fatigue upper bound ---
constraint fatigue <= max_fatigue;

% --- Total cost definition ---
constraint total_cost = cost_per_unit_ad1 * budget_ad1 + cost_per_unit_ad2 * budget_ad2;

% Objective
solve minimize total_cost;