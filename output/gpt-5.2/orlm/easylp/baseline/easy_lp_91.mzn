% Resource allocation between two warehouses X and Y

var 0..1000: x; % units allocated to warehouse X (integer)
var 0..1000: y; % units allocated to warehouse Y (integer)

% Constraints
constraint x + y <= 1000;           % total resources available
constraint 2*x + y >= 800;          % operational efficiency requirement
constraint abs(x - y) <= 200;       % balance requirement

% Objective: minimize total cost
var int: total_cost = 4*x + 3*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];