include "globals.mzn";

% Data (embedded from problem statement)
int: patties_gas = 20;     % patties per minute
int: patties_elec = 30;
int: oil_gas = 20;         % oil units per minute
int: oil_elec = 25;

int: min_patties = 150;
int: max_oil = 140;

% Decision variables: number of grills to buy
% Upper bounds are safe from oil limit: gas<=7 (7*20=140), elec<=5 (5*25=125)
var 0..7: gas;
var 0..5: elec;

% Constraints
constraint patties_gas * gas + patties_elec * elec >= min_patties;
constraint oil_gas * gas + oil_elec * elec <= max_oil;
constraint elec < gas;  % electric grills must be fewer than gas grills

% Objective: minimize total grills
var 0..12: total = gas + elec;

solve minimize total;

output [
  "gas = ", show(gas), "\n",
  "electric = ", show(elec), "\n",
  "total = ", show(total), "\n",
  "patties_per_min = ", show(patties_gas * gas + patties_elec * elec), "\n",
  "oil_per_min = ", show(oil_gas * gas + oil_elec * elec), "\n"
];