int: max_total_employees = 100;
int: min_x = 40;
int: min_y = 20;

int: cost_x = 50;
int: cost_y = 30;

var int: x; % employees assigned to Project X
var int: y; % employees assigned to Project Y

constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= max_total_employees;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "Employees_X = ", show(x), "\n",
  "Employees_Y = ", show(y), "\n",
  "Min_Total_Cost = $", show(total_cost), "\n"
];