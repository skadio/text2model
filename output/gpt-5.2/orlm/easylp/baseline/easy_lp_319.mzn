% Shipping allocation - minimize total cost with embedded data

int: CAP = 1000;

% Costs per shipment
int: c1 = 5;
int: c2 = 8;
int: c3 = 6;

% Decision variables: number of shipments of each type (nonnegative integers)
var 0..CAP: X1;
var 0..CAP: X2;
var 0..CAP: X3;

% Capacity constraint
constraint X1 + X2 + X3 <= CAP;

% Portfolio constraints
constraint 2 * X1 - 3 * X2 >= 200;
constraint 4 * X3 - X1 <= 500;

% Objective: minimize total cost
var int: TotalCost = c1 * X1 + c2 * X2 + c3 * X3;
solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "Minimum total cost ($)=", show(TotalCost), "\n"
];