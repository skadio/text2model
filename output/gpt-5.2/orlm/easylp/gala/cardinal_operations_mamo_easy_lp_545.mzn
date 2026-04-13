% Supply chain investment allocation (embedded data)

% Decision variables (integer investments)
var 0..3000: W;   % Warehouse
var 0..3000: T;   % Transport
var 0..3000: R;   % Retail

% Constraints
constraint W + T >= 500;
constraint abs(W - R) <= 2000;
constraint W + R = 3000;

% Objective: minimize total operational cost
var int: total_cost = 3*W + 2*T + 4*R;

solve minimize total_cost;

output [
  "W = ", show(W), "\n",
  "T = ", show(T), "\n",
  "R = ", show(R), "\n",
  "Minimum total cost (nearest dollar) = ", show(total_cost), "\n"
];