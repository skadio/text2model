% Experiment planning to maximize electricity production

int: metal_available = 800;
int: acid_available  = 750;

int: metal_alpha = 3;
int: acid_alpha  = 5;
int: elec_alpha  = 8;

int: metal_beta = 5;
int: acid_beta  = 4;
int: elec_beta  = 10;

var 0..metal_available div metal_alpha: x_alpha;
var 0..metal_available div metal_beta:  x_beta;

constraint metal_alpha * x_alpha + metal_beta * x_beta <= metal_available;
constraint acid_alpha  * x_alpha + acid_beta  * x_beta <= acid_available;

var int: total_electricity = elec_alpha * x_alpha + elec_beta * x_beta;

solve maximize total_electricity;

output [
  "alpha_experiments = ", show(x_alpha), "\n",
  "beta_experiments  = ", show(x_beta), "\n",
  "total_electricity = ", show(total_electricity), "\n",
  "metal_used        = ", show(metal_alpha * x_alpha + metal_beta * x_beta), " / ", show(metal_available), "\n",
  "acid_used         = ", show(acid_alpha * x_alpha + acid_beta * x_beta), " / ", show(acid_available), "\n"
];