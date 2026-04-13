% Parameters
int: cap_dense = 45;
int: cap_loose = 20;

int: elec_dense = 30;
int: elec_loose = 22;

int: min_loose = 5;

int: min_total_capacity = 1000;
int: max_electricity = 940;

% Variables
var 0..1000: n_dense;
var 0..1000: n_loose;
var 0..2000: total_lifts;

% Constraints
constraint n_loose >= min_loose;

constraint cap_dense * n_dense + cap_loose * n_loose >= min_total_capacity;

constraint elec_dense * n_dense + elec_loose * n_loose <= max_electricity;

constraint total_lifts = n_dense + n_loose;

% Objective
solve minimize total_lifts;