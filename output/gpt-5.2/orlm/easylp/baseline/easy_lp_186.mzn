% Production planning: minimize cost with embedded data

int: CAP = 1000;
int: METRIC_MIN = 500;
int: BALANCE_MAX = 400;

int: COST_X = 10;
int: COST_Y = 15;
int: COST_Z = 20;

var 0..CAP: x; % units of product X
var 0..CAP: y; % units of product Y
var 0..CAP: z; % units of product Z

constraint x + y + z <= CAP;

% Performance metric: 5x + 3y - z >= 500
constraint 5*x + 3*y - z >= METRIC_MIN;

% Portfolio balance: x + z - y <= 400
constraint x + z - y <= BALANCE_MAX;

var int: total_cost = COST_X*x + COST_Y*y + COST_Z*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];