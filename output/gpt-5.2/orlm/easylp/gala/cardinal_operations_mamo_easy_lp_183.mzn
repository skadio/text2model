% Energy production planning (integer quantities), minimize total cost
include "globals.mzn";

% Embedded data (as per problem statement)
int: demand = 5000;

int: coal_max = 3000;
int: gas_max  = 2000;
int: nuc_max  = 1500;

int: coal_cost = 4;
int: gas_cost  = 3;
int: nuc_cost  = 2;

% Decision variables: production quantities (whole numbers)
var 0..coal_max: coal;
var 0..gas_max:  gas;
var 0..nuc_max:  nuclear;

% Demand constraint
constraint coal + gas + nuclear >= demand;

% Objective: minimize total cost
var int: total_cost = coal_cost * coal + gas_cost * gas + nuc_cost * nuclear;

solve minimize total_cost;

output [
  "coal = ", show(coal), "\n",
  "gas = ", show(gas), "\n",
  "nuclear = ", show(nuclear), "\n",
  "total_production = ", show(coal + gas + nuclear), "\n",
  "total_cost = ", show(total_cost), "\n"
];