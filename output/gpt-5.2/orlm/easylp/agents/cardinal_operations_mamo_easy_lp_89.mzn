% Parameters
% Minimum combined workload requirement
int: min_total_hours = 10;

% Resource limitation on weighted hours: 2*X + 3*Y <= max_weighted_hours
int: max_weighted_hours = 24;

% Weights for resource limitation
int: weight_X = 2;
int: weight_Y = 3;

% Cost per hour for each task
int: cost_X = 8;
int: cost_Y = 5;

% Upper bounds derived from constraints (for safe bounded variables)
% From 2*X + 3*Y <= 24 and X,Y >= 0:
% X <= 12 (if Y=0), Y <= 8 (if X=0)
int: max_X = max_weighted_hours div weight_X; % 12
int: max_Y = max_weighted_hours div weight_Y; % 8


% Variables
% Integer hours allocated to tasks X and Y (non-negative and bounded)
var 0..max_X: hours_X;
var 0..max_Y: hours_Y;

% Total cost (integer since costs and hours are integers)
var 0..(cost_X * max_X + cost_Y * max_Y): total_cost;


% Constraints
% --- Workload requirement: ensure minimum combined hours ---
constraint hours_X + hours_Y >= min_total_hours;

% --- Resource limitation: enforce weighted-hours capacity ---
constraint weight_X * hours_X + weight_Y * hours_Y <= max_weighted_hours;

% --- Cost accounting: define total cost from allocated hours ---
constraint total_cost = cost_X * hours_X + cost_Y * hours_Y;


% Objective
solve minimize total_cost;