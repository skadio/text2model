% Renewable energy investment planning (integer linear optimization)

% Data (embedded from the description)
int: budget = 5000;
int: req_output = 20000;

int: outX = 10;
int: outY = 30;

int: costX = 50;
int: costY = 60;

% Decision variables: integer investment units in projects X and Y
var 0..budget: x;
var 0..budget: y;

% Constraints
constraint x + y <= budget;
constraint outX * x + outY * y >= req_output;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];