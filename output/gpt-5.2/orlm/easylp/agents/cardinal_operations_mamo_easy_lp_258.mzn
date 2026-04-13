% Parameters
int: budget_limit = 1000;                      % Maximum total investment allowed
int: effectiveness_min = 800;                  % Minimum required combined effectiveness
int: balance_limit = 300;                      % Max allowed |X - Y| for operational balance

int: eff_purchasing = 3;                       % Effectiveness coefficient for purchasing (X)
int: eff_manufacturing = 2;                    % Effectiveness coefficient for manufacturing (Y)
int: eff_distribution = 1;                     % Effectiveness coefficient for distribution (Z)

int: cost_purchasing = 2;                      % Cost per unit of purchasing investment
int: cost_manufacturing = 3;                   % Cost per unit of manufacturing investment
int: cost_distribution = 1;                    % Cost per unit of distribution investment

int: X_lb = 0;                                 % Lower bound for X (non-negative investment)
int: Y_lb = 0;                                 % Lower bound for Y (non-negative investment)
int: Z_lb = 0;                                 % Lower bound for Z (non-negative investment)

int: X_ub = budget_limit;                      % Upper bound for X (cannot exceed total budget)
int: Y_ub = budget_limit;                      % Upper bound for Y (cannot exceed total budget)
int: Z_ub = budget_limit;                      % Upper bound for Z (cannot exceed total budget)

% Variables
var X_lb..X_ub: X;                             % Integer investment in purchasing
var Y_lb..Y_ub: Y;                             % Integer investment in manufacturing
var Z_lb..Z_ub: Z;                             % Integer investment in distribution

var 0..(cost_purchasing*X_ub + cost_manufacturing*Y_ub + cost_distribution*Z_ub): total_cost;
                                                % Total cost to minimize

% Constraints
% --- Budget constraint: total investment cannot exceed the budget limit ---
constraint X + Y + Z <= budget_limit;

% --- Effectiveness constraint: combined effectiveness must meet minimum requirement ---
constraint eff_purchasing * X + eff_manufacturing * Y + eff_distribution * Z >= effectiveness_min;

% --- Operational balance constraint: difference between purchasing and manufacturing bounded ---
constraint abs(X - Y) <= balance_limit;

% --- Total cost definition: compute total cost from per-unit costs ---
constraint total_cost = cost_purchasing * X + cost_manufacturing * Y + cost_distribution * Z;

% Objective
solve minimize total_cost;