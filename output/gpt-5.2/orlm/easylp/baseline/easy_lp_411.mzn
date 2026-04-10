% Real estate investment allocation (integer properties)

var 0..15: x; % residential
var 0..20: y; % commercial
var 0..25: z; % industrial
var 0..30: w; % mixed-use

% Costs (in dollars)
int: cx = 30000;
int: cy = 40000;
int: cz = 50000;
int: cw = 60000;

% Constraints
constraint x + y <= 20;
constraint z + w <= 30;
constraint x + z >= 10;
constraint y + w >= 15;

% Objective: minimize total cost
var int: total_cost = cx*x + cy*y + cz*z + cw*w;
solve minimize total_cost;

output [
  "x(residential) = ", show(x), "\n",
  "y(commercial)  = ", show(y), "\n",
  "z(industrial)  = ", show(z), "\n",
  "w(mixed-use)   = ", show(w), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];