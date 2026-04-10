int: B_max = 5000;
int: cX = 1000;
int: cY = 1500;

int: min_2X_minus_Y = 1000;
int: max_X_minus_3Y = 2000;

var 0..B_max: X;  % budget allocated to channel X (integer dollars)
var 0..B_max: Y;  % budget allocated to channel Y (integer dollars)

constraint X + Y <= B_max;
constraint 2 * X - Y >= min_2X_minus_Y;
constraint X - 3 * Y <= max_X_minus_3Y;

var int: total_expenditure = cX * X + cY * Y;
solve minimize total_expenditure;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum expenditure ($) = ", show(total_expenditure), "\n"
];