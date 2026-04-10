% Parameters
int: max_total_resources = 100;              % Total resources available (units)
int: min_effectiveness = 350;               % Minimum required effectiveness (units)

int: eff_X = 5;                             % Effectiveness coefficient for Operation X
int: eff_Y = 3;                             % Effectiveness coefficient for Operation Y
int: eff_Z = 7;                             % Effectiveness coefficient for Operation Z

int: cost_X = 5000;                         % Cost per unit resource for Operation X ($)
int: cost_Y = 4000;                         % Cost per unit resource for Operation Y ($)
int: cost_Z = 6000;                         % Cost per unit resource for Operation Z ($)

% Variables
var 0..max_total_resources: x;              % Resources allocated to Operation X (integer units)
var 0..max_total_resources: y;              % Resources allocated to Operation Y (integer units)
var 0..max_total_resources: z;              % Resources allocated to Operation Z (integer units)

var 0..(cost_X*max_total_resources + cost_Y*max_total_resources + cost_Z*max_total_resources): total_cost;
                                            % Total cost ($), bounded by worst-case allocation

% Constraints
% Resource availability: total allocated resources cannot exceed the limit
constraint x + y + z <= max_total_resources;

% Minimum effectiveness requirement for achieving the strategic objective
constraint eff_X * x + eff_Y * y + eff_Z * z >= min_effectiveness;

% Strategy requirement: z must be at least twice the sum of x and y
constraint z - 2 * x - 2 * y >= 0;

% Define total cost as the linear combination of per-unit costs and allocations
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;