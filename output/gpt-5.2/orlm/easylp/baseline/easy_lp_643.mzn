% Environmental projects resource allocation and cost minimization
% All data embedded as requested.

% Decision variables: integer resource allocations
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Objective costs per unit resource
int: c1 = 4;
int: c2 = 2;
int: c3 = 3;
int: c4 = 5;

% Bounds on allocations (not specified numerically in the description);
% choose wide nonnegative bounds to make the model well-posed.
int: LB = 0;
int: UB = 100000;

constraint x1 >= LB /\ x1 <= UB;
constraint x2 >= LB /\ x2 <= UB;
constraint x3 >= LB /\ x3 <= UB;
constraint x4 >= LB /\ x4 <= UB;

% Constraints:
% 1) |0.5*x2 - x1| <= 100  ->  |x2 - 2*x1| <= 200 (scaled by 2)
constraint abs(x2 - 2*x1) <= 200;

% 2) x1 >= 0.7*x3 + 200  ->  10*x1 >= 7*x3 + 2000 (scaled by 10)
constraint 10*x1 >= 7*x3 + 2000;

% 3) |x4 - 0.6*x2| <= 150  ->  |10*x4 - 6*x2| <= 1500 (scaled by 10)
constraint abs(10*x4 - 6*x2) <= 1500;

% 4) |0.8*x3 - x1| <= 300  ->  |4*x3 - 5*x1| <= 1500 (scaled by 5)
constraint abs(4*x3 - 5*x1) <= 1500;

% 5) x4 >= x2 + 50
constraint x4 >= x2 + 50;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];