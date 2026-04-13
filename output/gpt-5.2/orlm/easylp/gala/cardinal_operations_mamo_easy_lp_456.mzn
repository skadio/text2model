% Resource allocation for projects X and Y (integer units), minimize total cost.

int: max_total = 200;
int: max_x = 150;
int: max_y = 100;

int: min_req = 100;          % 2*X + Y >= 100
int: max_diff = 50;          % |X - Y| <= 50

int: cost_x = 5000;
int: cost_y = 3000;

var 0..max_x: x;             % units allocated to project X
var 0..max_y: y;             % units allocated to project Y

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_req;
constraint abs(x - y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];