% Cargo allocation optimization (all data embedded)

int: capacity = 100;          % tons
int: min_value = 150;         % units

int: valueX = 2;
int: valueY = 3;

int: costX = 4;               % $/ton
int: costY = 5;               % $/ton

% Decision variables: whole tons
var 0..capacity: x;           % tons of cargo X
var 0..capacity: y;           % tons of cargo Y

% Constraints
constraint x + y <= capacity;
constraint valueX * x + valueY * y >= min_value;

% Objective: minimize total cost
var 0..100000: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), " tons\n",
  "y=", show(y), " tons\n",
  "total_cost=$", show(total_cost), "\n"
];