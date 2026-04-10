% Budget allocation across projects X, Y, Z
% Decision variables: whole-dollar budget allocations
var 0..5000: x;  % dollars allocated to X
var 0..5000: y;  % dollars allocated to Y
var 0..5000: z;  % dollars allocated to Z

% Constraints
constraint x + y + z <= 5000;
constraint x >= 1000;     % minimum viable investment for X
constraint y <= 3000;     % regulatory maximum for Y
constraint z >= 500;      % minimum investment for Z

% Costs per dollar invested (given "unit of investment" costs)
int: cost_per_dollar_x = 100;
int: cost_per_dollar_y = 200;
int: cost_per_dollar_z = 50;

var int: total_cost = cost_per_dollar_x * x + cost_per_dollar_y * y + cost_per_dollar_z * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];