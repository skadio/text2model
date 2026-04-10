% Parameters
int: total_resource_limit = 1000;          % Maximum total resources available
int: min_combined_yield_XY = 3000;         % Minimum required combined yield from X and Y
int: min_diff_Z_3Y = -500;                % Minimum allowed value for (Z - 3*Y)

int: yield_per_unit_X = 4;                % Yield coefficient for X in the combined yield constraint
int: yield_per_unit_Y = 5;                % Yield coefficient for Y in the combined yield constraint

int: cost_per_unit_X = 2;                 % Unit cost for allocating to X
int: cost_per_unit_Y = 3;                 % Unit cost for allocating to Y
int: cost_per_unit_Z = 1;                 % Unit cost for allocating to Z

% Variables
var 0..total_resource_limit: x;            % Integer units allocated to area X
var 0..total_resource_limit: y;            % Integer units allocated to area Y
var 0..total_resource_limit: z;            % Integer units allocated to area Z

var 0..(cost_per_unit_X + cost_per_unit_Y + cost_per_unit_Z) * total_resource_limit: total_cost;
                                          % Total cost (upper bound: all resources at max unit cost sum)

% Constraints
% Resource budget constraint: total allocations cannot exceed available resources
constraint x + y + z <= total_resource_limit;

% Production target constraint: combined yield from X and Y must meet minimum requirement
constraint yield_per_unit_X * x + yield_per_unit_Y * y >= min_combined_yield_XY;

% Interdependency constraint: Z minus three times Y must not be less than the minimum allowed difference
constraint z - 3 * y >= min_diff_Z_3Y;

% Total cost definition: compute total_cost from allocations and unit costs
constraint total_cost = cost_per_unit_X * x + cost_per_unit_Y * y + cost_per_unit_Z * z;

% Objective
solve minimize total_cost;