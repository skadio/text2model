% Fleet allocation / transportation planning (integer linear minimization)

% Data (embedded as required)
array[1..4] of int: cost = [2, 3, 4, 5];   % costs for X1..X4

% Decision variables: vehicles at each location (whole numbers)
var 0..300: X1;
var 0..200: X2;
var 0..300: X3;
var 0..400: X4;

% Constraints
constraint X1 + X2 <= 500;
constraint X3 + X4 <= 600;
constraint X1 + X3 >= 300;
constraint X2 + X4 >= 400;

% Objective: minimize total cost
var int: total_cost = cost[1]*X1 + cost[2]*X2 + cost[3]*X3 + cost[4]*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];