% HR staffing allocation: minimize onboarding cost

var 0..100: x; % hires in department X (integer)
var 0..100: y; % hires in department Y (integer)

constraint x + y >= 10;
constraint 2 * x + y <= 20;

var int: total_cost = 50 * x + 30 * y;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), "\n",
  "min_cost=$", show(total_cost), "\n"
];