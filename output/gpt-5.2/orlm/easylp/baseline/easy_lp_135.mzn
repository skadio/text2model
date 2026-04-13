int: max_total_investment = 20;

int: cost_x = 4;
int: cost_y = 5;

int: min_impact = 10;

var 0..max_total_investment: x; % investment in Project X (integer units)
var 0..max_total_investment: y; % investment in Project Y (integer units)

constraint x + y <= max_total_investment;
constraint 2*x + y >= min_impact;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];