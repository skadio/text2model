% Employee allocation to departments with payroll minimization

int: salary1 = 5000;
int: salary2 = 6000;
int: salary3 = 7000;
int: salary4 = 8000;

var 0..20: x1;
var 0..20: x2;
var 0..15: x3;
var 0..15: x4;

constraint x1 + x2 <= 40;
constraint x3 + x4 <= 30;
constraint x1 >= x3 + 10;
constraint x2 >= x4 + 5;

var int: total_cost = salary1*x1 + salary2*x2 + salary3*x3 + salary4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_payroll_cost=$", show(total_cost), "\n"
];