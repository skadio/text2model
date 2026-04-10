% Parameters (with values embedded)
float: time_sulfate = 0.5;
float: time_ginger  = 0.75;

int: min_sulfate = 100;
int: total_units = 400;

% Variables
var 0..total_units: sulfate;
var 0..total_units: ginger;

% Constraints
constraint sulfate >= min_sulfate;
constraint sulfate + ginger = total_units;
constraint sulfate <= 2 * ginger;

% Objective
solve minimize time_sulfate * int2float(sulfate) + time_ginger * int2float(ginger);

output [
  "sulfate = ", show(sulfate), "\n",
  "ginger = ", show(ginger), "\n",
  "total_time = ", show(time_sulfate * int2float(sulfate) + time_ginger * int2float(ginger)), "\n"
];