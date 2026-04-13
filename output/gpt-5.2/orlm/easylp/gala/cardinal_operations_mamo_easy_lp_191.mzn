% Vehicle allocation optimization (all data embedded)

% Decision variables: number of vehicles on each route (integers)
var 0..1000: x; % route X
var 0..1000: y; % route Y
var 0..1000: z; % route Z

% Objective: minimize total operating cost
var 0..10000000: total_cost = 5*x + 7*y + 3*z;

% Constraints
constraint x + y + z <= 1000;
constraint 2*x + 3*y >= 500;
constraint x + z - y <= 400;
constraint y >= z + 100;

solve minimize total_cost;

output [
  "x (route X) = ", show(x), "\n",
  "y (route Y) = ", show(y), "\n",
  "z (route Z) = ", show(z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];