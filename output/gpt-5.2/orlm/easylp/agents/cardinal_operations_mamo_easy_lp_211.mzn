% Parameters
int: total_resources = 100;                 % Total resources available (units)
int: x_min_extra_over_half_y = 10;          % X must be at least this many units more than half of Y
int: yz_max = 60;                           % Upper bound on Y + Z

int: cost_x = 5;                            % Cost per unit allocated to X
int: cost_y = 3;                            % Cost per unit allocated to Y
int: cost_z = 7;                            % Cost per unit allocated to Z


% Variables
var 0..total_resources: x;                  % Integer units allocated to department X
var 0..total_resources: y;                  % Integer units allocated to department Y
var 0..total_resources: z;                  % Integer units allocated to department Z

var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost;
                                            % Total cost of allocations (bounded)


% Constraints
% Resource budget: total allocation cannot exceed available resources
constraint x + y + z <= total_resources;

% Department X requirement: X >= (Y / 2) + extra
% Integer-safe form (avoid fractional division): 2*X >= Y + 2*extra
constraint 2 * x >= y + 2 * x_min_extra_over_half_y;

% Combined allocation limit for Y and Z
constraint y + z <= yz_max;

% Define total cost from allocations and unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;