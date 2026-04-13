% Parameters
int: patties_per_min_gas = 20;
int: patties_per_min_elec = 30;

int: oil_per_min_gas = 20;
int: oil_per_min_elec = 25;

int: min_patties_per_min = 150;
int: max_oil_per_min = 140;

% Variables
var 0..ceil(min_patties_per_min div patties_per_min_gas) + min_patties_per_min: gas_grills;
var 0..ceil(min_patties_per_min div patties_per_min_elec) + min_patties_per_min: elec_grills;

var 0..2*min_patties_per_min: total_grills;

% Constraints
constraint total_grills = gas_grills + elec_grills;

constraint patties_per_min_gas * gas_grills + patties_per_min_elec * elec_grills >= min_patties_per_min;

constraint oil_per_min_gas * gas_grills + oil_per_min_elec * elec_grills <= max_oil_per_min;

constraint elec_grills < gas_grills;

% Objective
solve minimize total_grills;