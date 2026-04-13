% Burger grill purchase optimization (all data embedded)

int: patties_gas = 20;
int: patties_elec = 30;

int: oil_gas = 20;
int: oil_elec = 25;

int: min_patties = 150;
int: max_oil = 140;

% Decision variables: number of grills to buy
var 0..100: gas;
var 0..100: elec;

constraint elec < gas;  % electric grills must be less than gas grills

constraint patties_gas * gas + patties_elec * elec >= min_patties;
constraint oil_gas * gas + oil_elec * elec <= max_oil;

solve minimize gas + elec;

output [
  "gas=", show(gas), "\n",
  "electric=", show(elec), "\n",
  "total_grills=", show(gas + elec), "\n",
  "patties_per_min=", show(patties_gas * gas + patties_elec * elec), "\n",
  "oil_per_min=", show(oil_gas * gas + oil_elec * elec), "\n"
];