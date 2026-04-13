% Real estate investment allocation (integer optimization)

% Decision variables: whole units invested in each property type
var 0..50: x; % residential
var 0..50: y; % commercial
var 0..50: z; % industrial

% Constraints
constraint x + y + z <= 50;
constraint 2*x + 3*y + z >= 30;
constraint abs(x - y) <= 10;
constraint y >= z + 5;

% Costs per unit (dollars)
int: cost_x = 500;
int: cost_y = 700;
int: cost_z = 900;

var int: total_cost = cost_x*x + cost_y*y + cost_z*z;

solve minimize total_cost;

output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "z (industrial)  = ", show(z), "\n",
  "total_cost ($)  = ", show(total_cost), "\n"
];