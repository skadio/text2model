% Chemical reactions optimization (integer linear program)

include "globals.mzn";

% Data (embedded as requested)
int: gas_avail = 1000;
int: water_avail = 800;

int: gas_A = 5;
int: water_A = 6;
int: prod_A = 10;

int: gas_B = 7;
int: water_B = 3;
int: prod_B = 8;

% Decision variables: number of reactions (nonnegative integers)
var 0..gas_avail div min(gas_A, gas_B): a;  % reactions of type A
var 0..gas_avail div min(gas_A, gas_B): b;  % reactions of type B

% Resource constraints
constraint gas_A * a + gas_B * b <= gas_avail;
constraint water_A * a + water_B * b <= water_avail;

% Objective: maximize total rare compound produced
var 0..prod_A * (gas_avail div gas_A) + prod_B * (gas_avail div gas_B): total_prod;
constraint total_prod = prod_A * a + prod_B * b;

solve maximize total_prod;

output [
  "Reactions A = ", show(a), "\n",
  "Reactions B = ", show(b), "\n",
  "Total compound = ", show(total_prod), "\n",
  "Gas used = ", show(gas_A*a + gas_B*b), " / ", show(gas_avail), "\n",
  "Water used = ", show(water_A*a + water_B*b), " / ", show(water_avail), "\n"
];