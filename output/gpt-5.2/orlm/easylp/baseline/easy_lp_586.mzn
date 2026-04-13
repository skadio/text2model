% Energy project resource allocation (all data embedded)

int: cost1 = 50;
int: cost2 = 60;
int: cost3 = 70;
int: cost4 = 80;

int: cap12 = 500;
int: cap34 = 600;

int: min_diff_3_vs_12 = 100;  % X3 - (X1+X2) >= 100
int: min_x4_over_x2 = 50;     % X4 - X2 >= 50

var int: X1 >= 0;
var int: X2 >= 0;
var int: X3 >= 0;
var int: X4 >= 0;

constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

constraint X3 - (X1 + X2) >= min_diff_3_vs_12;
constraint X4 - X2 >= min_x4_over_x2;

var int: total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "TotalCost=", show(total_cost), "\n"
];