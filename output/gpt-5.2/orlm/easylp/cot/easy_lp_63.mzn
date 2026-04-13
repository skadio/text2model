% Parameters (with values embedded)
int: max_bandwidth = 10000;
int: min_effectiveness = 5000;
int: eff_x = 2;
int: eff_y = 3;
float: cost_x = 0.2;
float: cost_y = 0.3;

% Variables
var 0..max_bandwidth: X;  % bandwidth for service X (Mbps, integer)
var 0..max_bandwidth: Y;  % bandwidth for service Y (Mbps, integer)
var float: total_cost;

% Constraints
constraint X + Y <= max_bandwidth;
constraint eff_x * X + eff_y * Y >= min_effectiveness;

constraint total_cost = cost_x * int2float(X) + cost_y * int2float(Y);

% Objective
solve minimize total_cost;