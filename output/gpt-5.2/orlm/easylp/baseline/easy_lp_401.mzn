% Military logistics resource allocation (all data embedded)

var 0..200: X1;
var 0..150: X2;
var 0..120: X3;
var 0..90:  X4;

% Constraints
constraint X1 + X2 >= 100;
constraint 2*X2 + 3*X3 <= 250;
constraint X4 - X1 >= 50;
constraint X3 - 2*X4 <= -30;   % i.e., X3 <= 2*X4 - 30

% Objective: minimize total supply points cost
var int: total_cost = 5000*X1 + 4000*X2 + 6000*X3 + 7000*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];