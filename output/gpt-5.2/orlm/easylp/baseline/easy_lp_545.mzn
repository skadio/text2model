% Supply chain resource allocation: Warehouse (W), Transport (T), Retail (R)

var int: W;
var int: T;
var int: R;

% Constraints
constraint W + T >= 500;          % minimum combined capacity
constraint abs(W - R) <= 2000;     % balance requirement
constraint W + R = 3000;           % budget limitation

% Objective: minimize operational cost
var int: total_cost = 3*W + 2*T + 4*R;
solve minimize total_cost;

output [
  "W = ", show(W), "\n",
  "T = ", show(T), "\n",
  "R = ", show(R), "\n",
  "total_cost = ", show(total_cost), "\n"
];