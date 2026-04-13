% Parameters
int: cap_dense = 45;
int: cap_loose = 20;
int: elec_dense = 30;
int: elec_loose = 22;
int: min_loose = 5;
int: min_total_capacity = 1000;
int: max_electricity = 940;

% Upper bounds from electricity limit (safe, integer)
int: ub_dense = max_electricity div elec_dense;
int: ub_loose = max_electricity div elec_loose;

% Variables
var 0..ub_dense: x_dense;
var 0..ub_loose: x_loose;

% Constraints
constraint x_loose >= min_loose;

constraint cap_dense * x_dense + cap_loose * x_loose >= min_total_capacity;

constraint elec_dense * x_dense + elec_loose * x_loose <= max_electricity;

% Objective
solve minimize x_dense + x_loose;