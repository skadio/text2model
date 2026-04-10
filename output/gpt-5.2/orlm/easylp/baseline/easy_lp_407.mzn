% Fleet distribution among four routes with embedded data

int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

int: max12 = 50;
int: max34 = 80;
int: min13 = 30;
int: min24 = 40;

% Decision variables: number of trucks on each route (nonnegative integers)
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

% Constraints
constraint X1 + X2 <= max12;
constraint X3 + X4 <= max34;
constraint X1 + X3 >= min13;
constraint X2 + X4 >= min24;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "Minimum total cost (rounded)=", show(total_cost), "\n"
];