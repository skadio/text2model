% Parameters
int: patties_per_min_gas = 20;
int: patties_per_min_elec = 30;

int: oil_per_min_gas = 20;
int: oil_per_min_elec = 25;

int: min_patties = 150;
int: max_oil = 140;

% Variables
var 0..ceil(min_patties div patties_per_min_gas) + ceil(min_patties div patties_per_min_elec): gas_grills;
var 0..ceil(min_patties div patties_per_min_gas) + ceil(min_patties div patties_per_min_elec): elec_grills;

% Constraints
constraint patties_per_min_gas * gas_grills + patties_per_min_elec * elec_grills >= min_patties;

constraint oil_per_min_gas * gas_grills + oil_per_min_elec * elec_grills <= max_oil;

constraint elec_grills < gas_grills;

% Objective
solve minimize gas_grills + elec_grills;