int: metal_J = 5;
int: water_J = 8;
int: poll_J  = 3;

int: metal_P = 9;
int: water_P = 6;
int: poll_P  = 5;

int: water_cap = 1500;
int: poll_cap  = 1350;

% Decision variables: number of times to run each process (nonnegative integers)
var 0..(water_cap div water_J): J;
var 0..(water_cap div water_P): P;

constraint water_J * J + water_P * P <= water_cap;
constraint poll_J  * J + poll_P  * P <= poll_cap;

var int: total_metal = metal_J * J + metal_P * P;

solve maximize total_metal;

output [
  "J = ", show(J), "\n",
  "P = ", show(P), "\n",
  "Total metal = ", show(total_metal), "\n",
  "Water used = ", show(water_J*J + water_P*P), " / ", show(water_cap), "\n",
  "Pollution = ", show(poll_J*J + poll_P*P), " / ", show(poll_cap), "\n"
];