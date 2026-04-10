% Parameters
int: total_allocation_limit = 1000;        % Maximum total units available
int: x_min_over_y = 200;                   % X must be at least this many units more than Y
int: z_min_over_y = 50;                    % Z must be at least this many units more than Y

int: cost_x = 4;                           % Cost per unit allocated to X
int: cost_y = 5;                           % Cost per unit allocated to Y
int: cost_z = 6;                           % Cost per unit allocated to Z

% Variables
var 0..total_allocation_limit: x;          % Units allocated to division X
var 0..total_allocation_limit: y;          % Units allocated to division Y
var 0..total_allocation_limit: z;          % Units allocated to division Z

% Upper bound uses worst-case: all 1000 allocated to each (loose but safe)
var 0..(cost_x*total_allocation_limit + cost_y*total_allocation_limit + cost_z*total_allocation_limit): total_cost;
                                            % Total cost of allocation

% Constraints
% Total allocation limit across divisions
constraint x + y + z <= total_allocation_limit;

% Minimum relative allocations (viability/operational requirements)
constraint x >= y + x_min_over_y;
constraint z >= y + z_min_over_y;

% Total cost definition (linking decision variables to total_cost)
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;