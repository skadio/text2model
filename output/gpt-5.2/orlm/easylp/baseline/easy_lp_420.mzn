% Energy optimization: Projects X and Y
% Minimize total investment cost with given constraints (integer decisions).

var 0..1000: x; % investment in Project X
var 0..1000: y; % investment in Project Y

constraint 5*x + 3*y <= 500;
constraint x + y >= 60;
constraint x - 2*y <= 30;

var int: total_cost = 50*x + 70*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_investment_cost = ", show(total_cost), "\n"
];