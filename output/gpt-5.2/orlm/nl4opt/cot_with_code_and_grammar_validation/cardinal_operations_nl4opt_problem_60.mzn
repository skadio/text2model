% Parameters
int: cap_dense = 45;
int: cap_loose = 20;

int: elec_dense = 30;
int: elec_loose = 22;

int: min_loose = 5;

int: min_total_capacity = 1000;
int: max_electricity = 940;

% Variables
var 0..(max_electricity div elec_dense): x_dense;
var min_loose..(max_electricity div elec_loose): x_loose;

var 0..(max_electricity div min(elec_dense, elec_loose)): total_lifts;

% Constraints
constraint total_lifts = x_dense + x_loose;

constraint cap_dense * x_dense + cap_loose * x_loose >= min_total_capacity;

constraint elec_dense * x_dense + elec_loose * x_loose <= max_electricity;

% Objective
solve minimize total_lifts;