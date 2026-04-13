% Resource allocation for four project types with integer units
% Minimize total cost subject to capacity and effectiveness constraints.

var 0..1000: X1;
var 0..1000: X2;
var 0..500:  X3;
var 0..500:  X4;

constraint X1 + X2 <= 1000;
constraint X3 + X4 <= 500;

constraint 2*X1 + 3*X2 >= 1200;
constraint 5*X3 + 6*X4 >= 2500;

var int: total_cost = 150*X1 + 200*X2 + 300*X3 + 400*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];