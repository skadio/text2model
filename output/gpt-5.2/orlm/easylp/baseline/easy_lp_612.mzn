% Resource allocation for four crops (integer units), minimize total cost.

int: MAX_LAND_X1X2 = 1000;
int: MIN_DIVERSITY = 500;
int: MAX_DIFF_X1_X4 = 200;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

var 0..1000000: x1;
var 0..1000000: x2;
var 0..1000000: x3;
var 0..1000000: x4;

% Constraints
constraint x1 + x2 <= MAX_LAND_X1X2;
constraint 2*x3 + 3*x4 >= MIN_DIVERSITY;
constraint abs(x1 - x4) <= MAX_DIFF_X1_X4;
constraint x3 >= 2*x2;  % (1/2)*x3 >= x2, avoiding fractions

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];