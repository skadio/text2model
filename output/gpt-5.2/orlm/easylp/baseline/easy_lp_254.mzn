int: budget_limit = 1000;
int: min_yz = 800;
int: max_diff_xz = 200;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 1;

var 0..budget_limit: x;
var 0..budget_limit: y;
var 0..budget_limit: z;

constraint x + y + z <= budget_limit;
constraint y + z >= min_yz;
constraint abs(x - z) <= max_diff_xz;

var int: total_cost = cost_x * x + cost_y * y + cost_z * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];