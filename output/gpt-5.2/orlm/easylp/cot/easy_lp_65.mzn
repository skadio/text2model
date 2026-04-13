% Parameters (with values embedded)
int: total_bandwidth = 10000;
int: cost_x = 20;
int: cost_y = 30;

% Convert fractional constraints to integer form by multiplying by 4:
% x - 0.5y >= 3000  ->  2x - y >= 6000  ->  8x - 4y >= 24000
% y - 0.75x <= 2000 ->  4y - 3x <= 8000 ->  16y - 12x <= 32000
int: c1_rhs = 24000; % for 8x - 4y >= 24000
int: c2_rhs = 32000; % for 16y - 12x <= 32000

% Variables
var 0..total_bandwidth: x; % bandwidth allocated to service X (integer units)
var 0..total_bandwidth: y; % bandwidth allocated to service Y (integer units)

var 0..(cost_x*total_bandwidth + cost_y*total_bandwidth): total_cost;

% Constraints
constraint x + y <= total_bandwidth;

constraint 8*x - 4*y >= c1_rhs;
constraint 16*y - 12*x <= c2_rhs;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;