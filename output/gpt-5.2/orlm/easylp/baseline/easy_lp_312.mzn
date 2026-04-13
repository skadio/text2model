% Resource allocation optimization (all data embedded)

int: TOTAL_MAX = 1000;
int: YZ_MAX = 800;

int: COST_X = 500;
int: COST_Y = 700;
int: COST_Z = 300;

var 0..TOTAL_MAX: x; % Division X (infantry)
var 0..TOTAL_MAX: y; % Division Y (artillery)
var 0..TOTAL_MAX: z; % Division Z (air support)

constraint x + y + z <= TOTAL_MAX;
constraint x >= 2 * y + 200;
constraint y + z <= YZ_MAX;

var int: total_cost = COST_X * x + COST_Y * y + COST_Z * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];