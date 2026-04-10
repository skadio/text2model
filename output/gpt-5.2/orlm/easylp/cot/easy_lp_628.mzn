% Parameters (with values embedded)
int: salary1 = 5000;
int: salary2 = 4000;
int: salary3 = 6000;
int: salary4 = 7000;

int: max_x1 = 50;
int: max_x2 = 60;
int: max_x3 = 40;
int: max_x4 = 40;

int: max_x1x2 = 100;
int: max_x3x4 = 80;

int: diff_x4_x2_max = 30;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint x3 + x4 <= max_x3x4;

% x1 must be at least 20 more than half of x3: x1 >= (x3 / 2) + 20
% Use integer-safe linear form: 2*x1 >= x3 + 40
constraint 2 * x1 >= x3 + 40;

% The difference between x4 and x2 should not exceed 30: |x4 - x2| <= 30
constraint abs(x4 - x2) <= diff_x4_x2_max;

constraint total_cost = salary1 * x1 + salary2 * x2 + salary3 * x3 + salary4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_monthly_salary=", show(total_cost), "\n"
];