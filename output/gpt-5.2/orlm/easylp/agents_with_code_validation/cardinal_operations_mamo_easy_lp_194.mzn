% Parameters
int: max_total_vehicles = 1000;          % Upper bound on total vehicles X+Y+Z
int: min_2x_plus_y     = 200;           % Lower bound on 2*X + Y
int: max_x_plus_z      = 300;           % Upper bound on X + Z

int: cost_x = 5;                         % Cost per vehicle of type X
int: cost_y = 4;                         % Cost per vehicle of type Y
int: cost_z = 3;                         % Cost per vehicle of type Z

% Variables
var 0..max_total_vehicles: x;            % Number of type X vehicles (non-negative integer)
var 0..max_total_vehicles: y;            % Number of type Y vehicles (non-negative integer)
var 0..max_total_vehicles: z;            % Number of type Z vehicles (non-negative integer)

var 0..(cost_x*max_total_vehicles + cost_y*max_total_vehicles + cost_z*max_total_vehicles): total_cost;
                                         % Total operating cost (safe linear upper bound)

% Constraints
% Total fleet size limit: X + Y + Z <= max_total_vehicles
constraint x + y + z <= max_total_vehicles;

% Operational requirement: 2*X + Y >= min_2x_plus_y
constraint 2 * x + y >= min_2x_plus_y;

% Budget/compatibility cap: X + Z <= max_x_plus_z
constraint x + z <= max_x_plus_z;

% Define total cost from vehicle counts and per-vehicle costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;