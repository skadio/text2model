% Real estate investment optimization (all data embedded)

int: cost_res = 300;
int: cost_com = 200;
int: cost_ind = 500;

int: max_units = 50;

int: roi_res = 5;
int: roi_com = 3;
int: roi_ind = 10;
int: roi_min = 100;

var 0..max_units: x; % residential units
var 0..max_units: y; % commercial units
var 0..max_units: z; % industrial units

constraint x + y + z <= max_units;
constraint roi_res*x + roi_com*y + roi_ind*z >= roi_min;
constraint x >= y;

var int: total_cost = cost_res*x + cost_com*y + cost_ind*z;

solve minimize total_cost;

output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "z (industrial)  = ", show(z), "\n",
  "total_cost = $", show(total_cost), "\n"
];