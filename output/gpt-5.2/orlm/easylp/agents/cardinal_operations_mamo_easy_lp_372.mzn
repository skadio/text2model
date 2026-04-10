% Parameters
% Maximum allowed hours per task
int: max_hours = 24;

% Hourly costs for tasks X1..X4
int: cost_X1 = 3;
int: cost_X2 = 4;
int: cost_X3 = 5;
int: cost_X4 = 6;

% Constraint constants
int: min_X1_X2 = 10;        % X1 + X2 >= 10
int: max_X2_X3 = 20;        % X2 + X3 <= 20
int: min_diff_X1_X4 = 5;    % X1 >= X4 + 5
int: max_diff_X3_X4 = 10;   % X3 <= X4 + 10


% Variables
% Scheduled hours for each task (whole hours, bounded by 0..24)
var 0..max_hours: hours_X1;
var 0..max_hours: hours_X2;
var 0..max_hours: hours_X3;
var 0..max_hours: hours_X4;

% Total cost in dollars (safe upper bound using max_hours)
var 0..(max_hours * (cost_X1 + cost_X2 + cost_X3 + cost_X4)): total_cost;


% Constraints
% --- Task hour-sum requirements ---
constraint hours_X1 + hours_X2 >= min_X1_X2;   % X1 + X2 must be at least 10
constraint hours_X2 + hours_X3 <= max_X2_X3;   % X2 + X3 must not exceed 20

% --- Task hour-difference requirements ---
constraint hours_X1 >= hours_X4 + min_diff_X1_X4;  % X1 must have at least 5 more hours than X4
constraint hours_X3 <= hours_X4 + max_diff_X3_X4;  % X3 must have at most 10 more hours than X4

% --- Total cost definition ---
constraint total_cost =
    cost_X1 * hours_X1 +
    cost_X2 * hours_X2 +
    cost_X3 * hours_X3 +
    cost_X4 * hours_X4;


% Objective
solve minimize total_cost;