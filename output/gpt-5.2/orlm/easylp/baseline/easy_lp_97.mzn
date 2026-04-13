% HR allocation between departments X and Y
% Minimize total annual salaries subject to hiring and space constraints.

int: salaryX = 50000;
int: salaryY = 60000;

% Decision variables (integers, nonnegative)
var 0..100: X;
var 0..100: Y;

constraint X + Y >= 10;
constraint 3 * X + 4 * Y <= 40;

var int: total_cost = salaryX * X + salaryY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_annual_salary=$", show(total_cost), "\n"
];