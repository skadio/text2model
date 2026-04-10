% Parameters
float: time_per_unit_sulfate = 0.5;
float: time_per_unit_ginger  = 0.75;

int: min_sulfate_units = 100;
int: total_units_required = 400;

int: max_sulfate_to_ginger_ratio = 2;

% Upper bounds for decision variables
int: max_sulfate_units = total_units_required;
int: max_ginger_units  = total_units_required;

% Decision variables
var 0..max_sulfate_units: sulfate_units;
var 0..max_ginger_units:  ginger_units;

% Constraints
constraint sulfate_units >= min_sulfate_units;
constraint sulfate_units + ginger_units = total_units_required;
constraint sulfate_units <= max_sulfate_to_ginger_ratio * ginger_units;

% Objective (avoid float(var int) cast; use int-scaled objective)
% total_time = 0.5*s + 0.75*g  <=>  4*total_time = 2*s + 3*g
var int: total_time_scaled = 2 * sulfate_units + 3 * ginger_units;

solve minimize total_time_scaled;

output [
  "sulfate_units = ", show(sulfate_units), "\n",
  "ginger_units = ", show(ginger_units), "\n",
  "total_time = ", show(total_time_scaled / 4.0), "\n"
];