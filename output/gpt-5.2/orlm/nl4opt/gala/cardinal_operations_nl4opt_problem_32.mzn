% Shampoo ingredients optimization (embedded data)

% Decision variables: units of each ingredient (assume whole units)
var 0..10000: sulfate;
var 0..10000: ginger;

% Total effectiveness time (minutes), scaled by 4 to avoid fractions:
% 0.5 = 2/4, 0.75 = 3/4  =>  time*4 = 2*sulfate + 3*ginger
var 0..100000: time_x4;

% Constraints from problem statement
constraint sulfate >= 100;
constraint sulfate + ginger = 400;
constraint sulfate <= 2 * ginger;

% Objective
constraint time_x4 = 2 * sulfate + 3 * ginger;
solve minimize time_x4;

output [
  "sulfate = ", show(sulfate), "\n",
  "ginger  = ", show(ginger), "\n",
  "time(min) = ", show(time_x4), "/4 = ", show(time_x4 / 4.0), "\n"
];