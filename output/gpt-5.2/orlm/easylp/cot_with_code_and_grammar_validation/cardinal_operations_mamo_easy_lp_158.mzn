int: cost_house = 400000;
int: cost_apt = 600000;

var 0..400: x;
var 0..300: y;

var int: total_investment;

constraint 6 * x + 8 * y >= 2000;
constraint 3 * x + 4 * y <= 1200;

constraint total_investment = cost_house * x + cost_apt * y;

solve minimize total_investment;

output [
  "x(houses) = ", show(x), "\n",
  "y(apartments) = ", show(y), "\n",
  "total_investment = ", show(total_investment), "\n"
];