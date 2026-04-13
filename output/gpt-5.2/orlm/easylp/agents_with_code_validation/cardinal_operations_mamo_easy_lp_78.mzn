% Parameters
% All data is embedded directly in this model as requested.
int: min_workers_requirement = 8;          % RHS for 2*X + Y >= 8
int: max_workers_budget = 15;              % RHS for X + 3*Y <= 15
int: cost_per_worker_x = 5000;             % Cost per worker on Project X
int: cost_per_worker_y = 3000;             % Cost per worker on Project Y

% Upper bounds derived from constraints to keep variables bounded.
% From X + 3*Y <= 15 => Y <= 5, and X <= 15 (when Y = 0).
int: ub_x = 15;
int: ub_y = 5;

% Variables
var 0..ub_x: workers_x;                    % Integer workers allocated to Project X
var 0..ub_y: workers_y;                    % Integer workers allocated to Project Y

var 0..(cost_per_worker_x*ub_x + cost_per_worker_y*ub_y): total_cost;
                                            % Total cost in dollars (integer)

% Constraints
% Staffing requirement: at least twice Project X workers plus Project Y workers is no less than 8
constraint 2 * workers_x + workers_y >= min_workers_requirement;

% Budget limit: Project X workers plus thrice Project Y workers cannot exceed 15
constraint workers_x + 3 * workers_y <= max_workers_budget;

% Total cost definition (link total_cost to decision variables)
constraint total_cost = cost_per_worker_x * workers_x + cost_per_worker_y * workers_y;

% Objective
solve minimize total_cost;