% Minty foam production planning (integer linear optimization)

int: mint_avail = 120;
int: active_avail = 100;
int: tar_max = 50;

% Demonstration 1 coefficients
int: mint1 = 10;
int: active1 = 20;
int: foam1 = 25;
int: tar1 = 5;

% Demonstration 2 coefficients
int: mint2 = 12;
int: active2 = 15;
int: foam2 = 18;
int: tar2 = 3;

% Decision variables: number of times to run each demonstration
var 0..mint_avail div mint1: d1;
var 0..mint_avail div mint2: d2;

% Resource constraints
constraint mint1 * d1 + mint2 * d2 <= mint_avail;
constraint active1 * d1 + active2 * d2 <= active_avail;
constraint tar1 * d1 + tar2 * d2 <= tar_max;

% Objective: maximize total minty foam produced
var int: total_foam = foam1 * d1 + foam2 * d2;

solve maximize total_foam;

output [
  "d1 = ", show(d1), "\n",
  "d2 = ", show(d2), "\n",
  "total_foam = ", show(total_foam), "\n",
  "mint_used = ", show(mint1*d1 + mint2*d2), " / ", show(mint_avail), "\n",
  "active_used = ", show(active1*d1 + active2*d2), " / ", show(active_avail), "\n",
  "tar_produced = ", show(tar1*d1 + tar2*d2), " / ", show(tar_max), "\n"
];