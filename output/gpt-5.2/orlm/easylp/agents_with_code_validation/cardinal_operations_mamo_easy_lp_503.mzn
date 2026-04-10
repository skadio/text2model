% Parameters
int: total_budget = 1000;               % Total budget limit across all campaigns

int: max_X = 500;                       % Maximum allocation for campaign X
int: max_Y = 400;                       % Maximum allocation for campaign Y
int: max_Z = 600;                       % Maximum allocation for campaign Z

int: cost_X = 100;                      % Cost per unit effectiveness for X
int: cost_Y = 200;                      % Cost per unit effectiveness for Y
int: cost_Z = 300;                      % Cost per unit effectiveness for Z

int: diff_limit = 150;                  % Limit for |Z - (3/4)X|
int: y_minus_z_min = 50;                % Minimum required difference Y - Z


% Variables
var 0..max_X: budget_X;                 % Budget allocated to campaign X (integer units)
var 0..max_Y: budget_Y;                 % Budget allocated to campaign Y (integer units)
var 0..max_Z: budget_Z;                 % Budget allocated to campaign Z (integer units)

% Upper bound is a safe worst-case cost if all max allocations were chosen
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;  % Total cost (bounded)


% Constraints
% --- Budget feasibility: total allocation must not exceed overall limit ---
constraint
  budget_X + budget_Y + budget_Z <= total_budget;

% --- Relationship between X and Y: X is at least half of Y (avoid fractions) ---
constraint
  2 * budget_X >= budget_Y;

% --- Z vs. three-fourths of X: |Z - (3/4)X| <= diff_limit (scaled to keep integers) ---
constraint
  abs(4 * budget_Z - 3 * budget_X) <= 4 * diff_limit;

% --- Minimum separation: Y must be at least y_minus_z_min more than Z ---
constraint
  budget_Y - budget_Z >= y_minus_z_min;

% --- Define total_cost from allocations and per-unit costs ---
constraint
  total_cost = cost_X * budget_X + cost_Y * budget_Y + cost_Z * budget_Z;


% Objective
solve minimize total_cost;