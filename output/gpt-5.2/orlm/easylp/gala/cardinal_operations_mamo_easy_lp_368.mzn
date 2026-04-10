% Construction projects resource allocation (integer linear minimization)

% Data (embedded as required)
int: c1 = 500;
int: c2 = 300;
int: c3 = 700;
int: c4 = 600;

int: max1 = 50;
int: max2 = 60;
int: max3 = 40;
int: max4 = 30;

% Decision variables: integer allocations (units)
var 0..max1: X1;
var 0..max2: X2;
var 0..max3: X3;
var 0..max4: X4;

% Constraints
constraint X1 + X2 <= 100;
constraint 2*X3 + X4 <= 120;
constraint X1 + X3 >= 60;
constraint X2 + X4 >= 80;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), "  X2=", show(X2), "  X3=", show(X3), "  X4=", show(X4), "\n",
  "TotalCost=$", show(total_cost), "\n"
];