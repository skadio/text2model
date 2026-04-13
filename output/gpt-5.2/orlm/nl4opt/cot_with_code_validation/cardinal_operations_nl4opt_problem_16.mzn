% Parameters
int: time_chlorine = 1;
int: time_softener = 2;

int: min_chlorine = 200;
int: total_chemicals = 500;

% chlorine <= 0.5 * softener  <=>  2*chlorine <= softener
int: ratio_mult = 2;

% Variables
var 0..total_chemicals: chlorine;
var 0..total_chemicals: softener;
var 0..(time_chlorine*total_chemicals + time_softener*total_chemicals): total_time;

% Constraints
constraint chlorine + softener = total_chemicals;
constraint chlorine >= min_chlorine;
constraint ratio_mult * chlorine <= softener;

constraint total_time = time_chlorine * chlorine + time_softener * softener;

% Objective
solve minimize total_time;