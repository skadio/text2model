% Scheduling allocation problem (integer hours) - all data embedded

var 0..24: X1;
var 0..12: X2;
var 0..30: X3;

% Operational constraints
constraint 2*X1 + 3*X2 + 1*X3 >= 10;
constraint 4*X1 + 5*X2 + 2*X3 <= 20;
constraint 1*X1 - 2*X2 + 1*X3 >= 8;

% Cost (units per hour)
var int: TotalCost = 5*X1 + 6*X2 + 3*X3;

solve minimize TotalCost;

output [
  "X1=", show(X1), " hours\n",
  "X2=", show(X2), " hours\n",
  "X3=", show(X3), " hours\n",
  "Minimum total cost=", show(TotalCost), "\n"
];