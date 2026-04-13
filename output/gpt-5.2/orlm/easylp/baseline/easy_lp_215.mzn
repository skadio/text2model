% Resource allocation problem (all data embedded)

var 0..500: X; % purchasing
var 0..300: Y; % sales
var 0..200: Z; % logistics

% Constraints
constraint X + Y <= 1000;
constraint Y + Z <= 800;
constraint abs(X - Z) >= 200;

% Objective: minimize total cost
var int: total_cost = 5*X + 3*Y + 4*Z;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];