% Maximize rare compound production from two reactions under resource limits

int: gas_available = 1000;
int: water_available = 800;

int: gas_A = 5;
int: water_A = 6;
int: output_A = 10;

int: gas_B = 7;
int: water_B = 3;
int: output_B = 8;

var 0..gas_available div min(gas_A, gas_B): xA; % number of reaction A runs
var 0..gas_available div min(gas_A, gas_B): xB; % number of reaction B runs

constraint gas_A * xA + gas_B * xB <= gas_available;
constraint water_A * xA + water_B * xB <= water_available;

var int: total_output = output_A * xA + output_B * xB;

solve maximize total_output;

output [
  "Reactions A: ", show(xA), "\n",
  "Reactions B: ", show(xB), "\n",
  "Total rare compound: ", show(total_output), "\n"
];