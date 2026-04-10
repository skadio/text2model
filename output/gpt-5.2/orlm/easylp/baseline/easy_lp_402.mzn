% Resource allocation MILP (all data embedded)

int: maxX12 = 1000;
int: min2X1plusX3 = 800;
int: maxX2plus3X4 = 600;
int: minX1minusHalfX4 = 200;

% Costs
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Decision variables (whole-number allocations)
var 0..100000: X1;
var 0..100000: X2;
var 0..100000: X3;
var 0..100000: X4;

% Constraints
constraint X1 + X2 <= maxX12;
constraint 2*X1 + X3 >= min2X1plusX3;
constraint X2 + 3*X4 <= maxX2plus3X4;

% X1 - 0.5*X4 >= 200  <=>  2*X1 - X4 >= 400
constraint 2*X1 - X4 >= 2*minX1minusHalfX4;

% Objective: minimize total cost
var int: TotalCost = c1*X1 + c2*X2 + c3*X3 + c4*X4;
solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "MinTotalCost=", show(TotalCost), "\n"
];