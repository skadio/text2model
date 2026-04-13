% Parameters
int: max_total_weight = 40000;          % Maximum total shippable weight (lb)
int: min_total_vehicles = 3000;         % Minimum combined number of vehicles
int: cost_X = 10;                       % Cost per vehicle type X ($)
int: cost_Y = 20;                       % Cost per vehicle type Y ($)

% NOTE: The problem statement mentions different capacities for X and Y,
% but does not provide the per-vehicle capacities. To make the model solvable
% with embedded data (no .dzn), we must set them here. Replace with correct values if known.
int: cap_X = 10;                        % Capacity (lb) per vehicle type X
int: cap_Y = 20;                        % Capacity (lb) per vehicle type Y

% Variables
var 0..min_total_vehicles: num_X;       % Number of vehicles of type X (integer, nonnegative)
var 0..min_total_vehicles: num_Y;       % Number of vehicles of type Y (integer, nonnegative)
var 0..(cost_Y * min_total_vehicles): total_cost;  % Total cost ($), bounded

% Constraints
% --- Vehicle count requirements ---
constraint
  num_X + num_Y >= min_total_vehicles;

% --- Weight (capacity) limitation ---
constraint
  cap_X * num_X + cap_Y * num_Y <= max_total_weight;

% --- Total cost definition ---
constraint
  total_cost = cost_X * num_X + cost_Y * num_Y;

% Objective
solve minimize total_cost;