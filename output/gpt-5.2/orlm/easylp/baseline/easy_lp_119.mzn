% Tourism trips planning: minimize total investment

var 0..50: x; % number of trip X
var 0..50: y; % number of trip Y

constraint x + y <= 50;
constraint 2*x + 3*y >= 30;

var int: total_investment = 100*x + 200*y;

solve minimize total_investment;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_investment = $", show(total_investment), "\n"
];