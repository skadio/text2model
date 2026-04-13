% Parameters
int: total_bandwidth_max = 10000;
int: effectiveness_min = 5000;

int: eff_x = 2;
int: eff_y = 3;

% Scale costs to avoid floats: $0.2 = 2/10, $0.3 = 3/10
int: cost_x_num = 2;
int: cost_y_num = 3;
int: cost_den = 10;

% Upper bounds based on total bandwidth limit
int: x_max = total_bandwidth_max;
int: y_max = total_bandwidth_max;

% Variables
var 0..x_max: x; % Mbps allocated to service X (integer)
var 0..y_max: y; % Mbps allocated to service Y (integer)

% Total cost in tenths of dollars (to keep integer arithmetic)
var 0..(cost_x_num * x_max + cost_y_num * y_max): total_cost_tenths;

% Constraints
constraint x + y <= total_bandwidth_max;
constraint eff_x * x + eff_y * y >= effectiveness_min;

constraint total_cost_tenths = cost_x_num * x + cost_y_num * y;

% Objective
solve minimize total_cost_tenths;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=$", show(total_cost_tenths div cost_den), ".", show(total_cost_tenths mod cost_den), "\n"
];