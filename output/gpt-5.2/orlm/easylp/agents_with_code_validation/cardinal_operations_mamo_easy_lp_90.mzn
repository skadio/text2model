% Parameters
int: total_resources = 5000;          % Total available resources (budget limit)
int: min_ratio = 2;                   % X must be at least twice Y  => X >= 2*Y
int: service_req = 1000;              % Service level requirement: 2*X + Y >= 1000
int: cost_x = 4;                      % Cost per unit allocated to center X
int: cost_y = 3;                      % Cost per unit allocated to center Y

% Variables
var 0..total_resources: x;            % Units allocated to distribution center X (integer)
var 0..total_resources: y;            % Units allocated to distribution center Y (integer)
var 0..(cost_x*total_resources + cost_y*total_resources): total_cost; % Total cost (bounded)

% Constraints
% Resource availability: total allocation cannot exceed available resources
constraint x + y <= total_resources;

% Balanced distribution: allocation to X must be at least min_ratio times allocation to Y
constraint x >= min_ratio * y;

% Service level requirement: combined strength must meet or exceed service_req
constraint 2 * x + y >= service_req;

% Total cost definition: link total_cost to decision variables and per-unit costs
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];