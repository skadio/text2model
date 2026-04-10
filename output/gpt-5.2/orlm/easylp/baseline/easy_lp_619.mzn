% Task scheduling / allocation as an integer linear minimization

var 0..10: X1;
var 0..15: X2;
var 0..20: X3;
var 0..25: X4;

% Combined duration constraints
constraint X1 + X2 <= 8;
constraint X2 + X3 <= 12;
constraint X3 + X4 >= 14;

% Balance requirements
constraint 2*X2 - X1 - X3 <= -6;

% X3 - 0.5*X4 >= X2  <=>  2*X3 - X4 >= 2*X2
constraint 2*X3 - X4 >= 2*X2;

% Objective: minimize total cost
var int: total_cost = 10*X1 + 20*X2 + 30*X3 + 40*X4;
solve minimize total_cost;

output [
  "X1=", show(X1), " hours\n",
  "X2=", show(X2), " hours\n",
  "X3=", show(X3), " hours\n",
  "X4=", show(X4), " hours\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];