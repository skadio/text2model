% Parameters
% Limits on allocations
int: max_total_resources = 1000;        % x + y + z <= 1000
int: min_balanced_portfolio = 500;      % 2x + y >= 500
int: max_technical_limit = 600;         % x + 2z <= 600

% Unit costs
int: cost_X = 6;                        % cost per unit for Project X
int: cost_Y = 3;                        % cost per unit for Project Y
int: cost_Z = 5;                        % cost per unit for Project Z


% Variables
% Integer allocations (nonnegative)
var 0..max_total_resources: x;          % units allocated to Project X
var 0..max_total_resources: y;          % units allocated to Project Y
var 0..max_total_resources: z;          % units allocated to Project Z

% Total cost (safe upper bound: allocate all max_total_resources to each project)
var 0..(cost_X*max_total_resources + cost_Y*max_total_resources + cost_Z*max_total_resources): total_cost;


% Constraints
% Resource availability: total allocation across all projects within budget
constraint x + y + z <= max_total_resources;

% Balanced portfolio requirement: ensure sufficient combined investment in X and Y
constraint 2 * x + y >= min_balanced_portfolio;

% Technical/logistical limitation: restrict combined investment in X and Z
constraint x + 2 * z <= max_technical_limit;

% Total cost definition: linear cost aggregation from project allocations
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;


% Objective
solve minimize total_cost;