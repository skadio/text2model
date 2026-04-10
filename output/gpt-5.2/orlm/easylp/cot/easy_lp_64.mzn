% Parameters (with values embedded)
int: costX = 500;
int: costY = 700;

int: perf_req = 2000;          % 2*X + 3*Y >= 2000
int: total_cap = 1500;         % X + Y <= 1500

% Variables
var 0..total_cap: x;           % resources allocated to Project X (integer, nonnegative)
var 0..total_cap: y;           % resources allocated to Project Y (integer, nonnegative)

var int: total_cost;

% Constraints
constraint 2*x + 3*y >= perf_req;
constraint x + y <= total_cap;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;