% Resource allocation problem (all data embedded)

int: max_total_resources = 100;
int: min_impact = 300;
int: max_diff = 20;

int: impact_x = 3;
int: impact_y = 4;

int: cost_x = 5;
int: cost_y = 2;

var 0..max_total_resources: x; % units to initiative X (integer)
var 0..max_total_resources: y; % units to initiative Y (integer)

constraint x + y <= max_total_resources;
constraint impact_x * x + impact_y * y >= min_impact;
constraint abs(x - y) <= max_diff;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];