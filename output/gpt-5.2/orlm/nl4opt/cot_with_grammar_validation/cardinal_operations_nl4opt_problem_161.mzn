% Parameters
int: patties_per_min_gas = 20;
int: patties_per_min_elec = 30;
int: oil_per_min_gas = 20;
int: oil_per_min_elec = 25;

int: min_patties = 150;
int: max_oil = 140;

% Variables
var 0..1000: gas_grills;
var 0..1000: electric_grills;
var 0..2000: total_grills;

% Constraints
constraint patties_per_min_gas * gas_grills + patties_per_min_elec * electric_grills >= min_patties;

constraint oil_per_min_gas * gas_grills + oil_per_min_elec * electric_grills <= max_oil;

constraint electric_grills < gas_grills;

constraint total_grills = gas_grills + electric_grills;

% Objective
solve minimize total_grills;