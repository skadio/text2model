% Resource allocation for two projects (integer variables)
var 0..1000: x; % Project X allocation
var 0..500:  y; % Project Y allocation

% Constraints
constraint 5*x + 3*y >= 60;
constraint 4*x + y <= 80;
constraint x - y >= 10;

% Objective: minimize total cost
var int: total_cost = 20*x + 30*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];