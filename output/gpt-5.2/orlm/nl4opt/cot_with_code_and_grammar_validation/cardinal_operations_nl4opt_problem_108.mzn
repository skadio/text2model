% Parameters
int: slices_per_min_manual = 5;
int: slices_per_min_auto = 8;

int: grease_per_min_manual = 3;
int: grease_per_min_auto = 6;

int: min_slices_per_min = 50;
int: max_grease_per_min = 35;

% Variables
var 0..ceil(int2float(min_slices_per_min) / int2float(slices_per_min_manual)): manual;
var 0..ceil(int2float(min_slices_per_min) / int2float(slices_per_min_auto)): automatic;

% Constraints
constraint
  slices_per_min_manual * manual + slices_per_min_auto * automatic >= min_slices_per_min;

constraint
  grease_per_min_manual * manual + grease_per_min_auto * automatic <= max_grease_per_min;

constraint
  manual < automatic;

% Objective
solve minimize manual + automatic;