% Parameters (with values embedded)
int: gas_patties_per_min = 20;
int: elec_patties_per_min = 30;
int: gas_oil_per_min = 20;
int: elec_oil_per_min = 25;

int: min_patties = 150;
int: max_oil = 140;

% Upper bounds from oil constraint (safe bounds)
int: max_gas = max_oil div gas_oil_per_min;   % 140 div 20 = 7
int: max_elec = max_oil div elec_oil_per_min; % 140 div 25 = 5

% Variables
var 0..max_gas: gas_grills;
var 0..max_elec: electric_grills;

% Constraints
constraint gas_patties_per_min * gas_grills + elec_patties_per_min * electric_grills >= min_patties;
constraint gas_oil_per_min * gas_grills + elec_oil_per_min * electric_grills <= max_oil;
constraint electric_grills < gas_grills;

% Objective
solve minimize gas_grills + electric_grills;