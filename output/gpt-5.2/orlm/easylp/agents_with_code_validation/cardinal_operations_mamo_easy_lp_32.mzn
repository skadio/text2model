% Parameters
int: max_total_vehicles = 1000;     % Maximum vehicles that can be assigned across both routes
int: min_vehicles_x    = 400;       % Minimum vehicles required on route X
int: min_vehicles_y    = 300;       % Minimum vehicles required on route Y
int: cost_per_x        = 50;        % Daily cost per vehicle on route X ($)
int: cost_per_y        = 60;        % Daily cost per vehicle on route Y ($)

% Variables
var 0..max_total_vehicles: vehicles_x;  % Number of vehicles assigned to route X
var 0..max_total_vehicles: vehicles_y;  % Number of vehicles assigned to route Y
var 0..(cost_per_x*max_total_vehicles + cost_per_y*max_total_vehicles): total_daily_cost;
  % Total daily cost in dollars

% Constraints
% Fleet size and service level constraints
constraint vehicles_x + vehicles_y <= max_total_vehicles;
constraint vehicles_x >= min_vehicles_x;
constraint vehicles_y >= min_vehicles_y;

% Cost definition constraint
constraint total_daily_cost = cost_per_x * vehicles_x + cost_per_y * vehicles_y;

% Objective
solve minimize total_daily_cost;

output [
  "vehicles_x = ", show(vehicles_x), "\n",
  "vehicles_y = ", show(vehicles_y), "\n",
  "total_daily_cost = $", show(total_daily_cost), "\n"
];