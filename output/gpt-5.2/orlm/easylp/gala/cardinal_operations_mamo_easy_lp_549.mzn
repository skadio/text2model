% Supply chain allocation MILP (all data embedded)

% Decision variables: integer resource allocations
var int: x1;
var int: x2;
var int: x3;

% Problem data
int: B = 5000;                 % total allocation budget (units)
int: c1 = 10; int: c2 = 20; int: c3 = 30;   % costs per unit

% Constraints
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0;

% Total allocation cannot exceed 5000
constraint x1 + x2 + x3 <= B;

% 5*x1 - 2.5*x2 >= 1000  -> 10*x1 - 5*x2 >= 2000
constraint 10*x1 - 5*x2 >= 2000;

% 3*x2 + 4.5*x3 <= 4000 -> 6*x2 + 9*x3 <= 8000
constraint 6*x2 + 9*x3 <= 8000;

% Balance: x1 - 1.5*x2 = x3 -> 2*x1 - 3*x2 = 2*x3
constraint 2*x1 - 3*x2 = 2*x3;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost_rounded = ", show(total_cost), "\n"
];