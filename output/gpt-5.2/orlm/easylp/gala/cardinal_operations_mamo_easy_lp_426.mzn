% Production planning for products X and Y (all data embedded)

% Parameters
int: costX = 50;
int: costY = 75;

int: cap_total = 1200;     % X + Y <= 1200
int: min_gap = 300;        % X - Y >= 300 (more X than Y)
int: storage_cap = 2000;   % 2X + Y <= 2000

% Decision variables (whole numbers)
var 0..cap_total: x;       % units of product X
var 0..cap_total: y;       % units of product Y

% Constraints
constraint x + y <= cap_total;
constraint x - y >= min_gap;
constraint 2*x + y <= storage_cap;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];