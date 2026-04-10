% Manufacturing production planning - embedded data

var 0..600: X1;
var 0..500: X2;
var 0..400: X3;
var 0..300: X4;

% Constraints
constraint X1 + X2 <= 1000;                 % raw material
constraint 2*X1 + X3 <= 1500;               % machine capacity
constraint 3*X2 + 2*X4 >= 1200;             % demand requirement
constraint abs(X3 - X4) <= 500;             % balanced mix

% Objective: minimize total cost
var int: TotalCost = 10*X1 + 12*X2 + 20*X3 + 15*X4;
solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "TotalCost=", show(TotalCost), "\n"
];