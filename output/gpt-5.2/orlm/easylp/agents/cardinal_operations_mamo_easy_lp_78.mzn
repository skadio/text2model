% Parameters
% All data embedded directly in the model (no .dzn file expected)

int: min_workers_requirement = 8;      % RHS for 2*X + Y >= 8
int: max_workers_budget = 15;          % RHS for X + 3*Y <= 15
int: cost_per_worker_x = 5000;         % cost per worker on Project X
int: cost_per_worker_y = 3000;         % cost per worker on Project Y

% Safe upper bounds for integer workers derived from constraints:
% From X + 3*Y <= 15 => X <= 15, Y <= 5
int: max_x = 15;                       % upper bound for workers on X
int: max_y = 5;                        % upper bound for workers on Y


% Variables
var 0..max_x: workers_x;               % number of workers allocated to Project X (integer)
var 0..max_y: workers_y;               % number of workers allocated to Project Y (integer)

var 0..(cost_per_worker_x*max_x + cost_per_worker_y*max_y): total_cost; % total cost in dollars


% Constraints

% Workforce requirement (2*X + Y >= 8)
constraint 2 * workers_x + workers_y >= min_workers_requirement;

% Budget / capacity constraint (X + 3*Y <= 15)
constraint workers_x + 3 * workers_y <= max_workers_budget;

% Cost definition
constraint total_cost = cost_per_worker_x * workers_x + cost_per_worker_y * workers_y;


% Objective
solve minimize total_cost;