% HR budget allocation optimization (all data embedded)

int: cost1 = 5000;
int: cost2 = 6000;
int: cost3 = 7000;
int: cost4 = 8000;

% Decision variables: whole-number resource allocations
var int: X1;
var int: X2;
var int: X3;
var int: X4;

% Derived objective value (total cost in dollars)
var int: TotalCost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

constraint X1 + X2 <= 50;
constraint X3 + X4 <= 70;
constraint X1 - 2*X3 >= 10;
constraint X2 - 2*X4 <= 20;

% Natural bounds (nonnegative allocations)
constraint X1 >= 0 /\ X2 >= 0 /\ X3 >= 0 /\ X4 >= 0;

solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "MinimumTotalCostDollars=", show(TotalCost), "\n"
];