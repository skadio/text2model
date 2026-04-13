% Transportation vehicle allocation across routes X, Y, Z
% Minimize total cost subject to operational constraints

var 0..1000: x; % vehicles on route X
var 0..1000: y; % vehicles on route Y
var 0..1000: z; % vehicles on route Z

% Constraints
constraint x + y <= 100;
constraint y + z <= 150;
constraint x + z >= 80;

% Objective: minimize total cost
var int: total_cost = 2*x + 3*y + 4*z;
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];