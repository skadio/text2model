% Reforestation project: minimize planting cost with integer numbers of trees

var 0..50: X;
var 0..50: Y;

constraint X + Y <= 50;          % space limitation
constraint X >= 2 * Y;           % at least twice as many X as Y
constraint X + Y >= 30;          % minimum total trees
constraint X - Y <= 10;          % not more than 10 more X than Y

var int: total_cost = 10 * X + 20 * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];