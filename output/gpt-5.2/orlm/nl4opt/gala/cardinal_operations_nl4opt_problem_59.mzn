% Electricity production planning (integer linear optimization)
% Embed all data directly as requested.

include "globals.mzn";

% Data
int: metal_avail = 800;
int: acid_avail  = 750;

int: metal_alpha = 3;
int: acid_alpha  = 5;
int: elec_alpha  = 8;

int: metal_beta  = 5;
int: acid_beta   = 4;
int: elec_beta   = 10;

% Decision variables: number of experiments (nonnegative integers)
var 0..metal_avail: alpha;
var 0..metal_avail: beta;

% Resource constraints
constraint metal_alpha * alpha + metal_beta * beta <= metal_avail;
constraint acid_alpha  * alpha + acid_beta  * beta <= acid_avail;

% Objective: maximize total electricity
var 0..(elec_alpha*metal_avail + elec_beta*metal_avail): total_elec;
constraint total_elec = elec_alpha * alpha + elec_beta * beta;

solve maximize total_elec;

output [
  "alpha = ", show(alpha), "\n",
  "beta  = ", show(beta), "\n",
  "total_electricity = ", show(total_elec), "\n",
  "metal_used = ", show(metal_alpha*alpha + metal_beta*beta), " / ", show(metal_avail), "\n",
  "acid_used  = ", show(acid_alpha*alpha + acid_beta*beta), " / ", show(acid_avail), "\n"
];