include "globals.mzn";

/* Data (embedded as required) */
int: maxTV = 700;
int: maxRadio = 600;
int: maxSocial = 500;
int: maxOutdoor = 400;

/* Costs per unit (in thousands) */
float: cTV = 0.5;
float: cRadio = 0.6;
float: cSocial = 0.8;
float: cOutdoor = 1.2;

/* Decision variables: whole-number budget allocations (units) */
var 0..maxTV: TV;
var 0..maxRadio: Radio;
var 0..maxSocial: Social;
var 0..maxOutdoor: Outdoor;

/* Constraints */
constraint TV + Radio >= 500;
constraint abs(Social - Radio) <= 200;
constraint Outdoor >= TV + 100;
constraint Social + Outdoor <= 800;

/* Objective: minimize total cost (in thousands) */
var float: total_cost = cTV*int2float(TV)
                      + cRadio*int2float(Radio)
                      + cSocial*int2float(Social)
                      + cOutdoor*int2float(Outdoor);

solve minimize total_cost;

/* Output with two decimals */
output [
  "TV = ", show(TV), "\n",
  "Radio = ", show(Radio), "\n",
  "Social = ", show(Social), "\n",
  "Outdoor = ", show(Outdoor), "\n",
  "Minimum total cost (thousands) = ", show_float(2, total_cost), "\n"
];