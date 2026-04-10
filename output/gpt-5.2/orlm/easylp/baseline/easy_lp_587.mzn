% Resource allocation / investment planning (all data embedded)

int: n = 4;
set of int: P = 1..n;

% Costs per unit investment
array[P] of int: cost = [60, 50, 70, 80];

% Decision variables: whole-number investments
array[P] of var int: x;
constraint x[1] >= 0 /\ x[1] <= 400; % X1
constraint x[2] >= 0 /\ x[2] <= 350; % X2
constraint x[3] >= 0 /\ x[3] <= 250; % X3
constraint x[4] >= 0 /\ x[4] <= 150; % X4

% Constraints
constraint x[1] + x[2] <= 500;        % X1 + X2 budget limit
constraint x[3] + x[4] <= 300;        % X3 + X4 technical limit
constraint x[1] + x[3] >= 200;        % diversity requirement

% Strategic constraint: X2 - 0.5*X4 >= 100
% Multiply by 2 to keep it integral: 2*X2 - X4 >= 200
constraint 2*x[2] - x[4] >= 200;

% Objective: minimize total cost
var int: total_cost = sum(p in P)(cost[p] * x[p]);
solve minimize total_cost;

output [
  "X1=", show(x[1]), "\n",
  "X2=", show(x[2]), "\n",
  "X3=", show(x[3]), "\n",
  "X4=", show(x[4]), "\n",
  "TotalCost=", show(total_cost), "\n"
];