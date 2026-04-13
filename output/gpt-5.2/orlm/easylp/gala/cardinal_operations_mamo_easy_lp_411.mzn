% Real estate investment allocation (integer quantities)
% Minimize total cost subject to portfolio constraints.

int: cost_x = 30000; % residential
int: cost_y = 40000; % commercial
int: cost_z = 50000; % industrial
int: cost_w = 60000; % mixed-use

% Bounds (given)
var 0..15: x; % residential
var 0..20: y; % commercial
var 0..25: z; % industrial
var 0..30: w; % mixed-use

% Constraints
constraint x + y <= 20;
constraint z + w <= 30;
constraint x + z >= 10;
constraint y + w >= 15;

% Objective: minimize total cost
var int: total_cost = cost_x*x + cost_y*y + cost_z*z + cost_w*w;

solve minimize total_cost;

output [
  "x(residential) = ", show(x), "\n",
  "y(commercial)  = ", show(y), "\n",
  "z(industrial)  = ", show(z), "\n",
  "w(mixed-use)   = ", show(w), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];