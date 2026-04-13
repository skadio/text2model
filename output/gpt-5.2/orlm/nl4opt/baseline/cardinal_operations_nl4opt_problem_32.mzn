% Shampoo mixture optimization: sulfate vs ginger
% Minimize total time for mixture to be effective (sequential addition)

% Decision variables: units of each ingredient (assume integer units)
var 0..10000: sulfate;
var 0..10000: ginger;

% Parameters (minutes per unit)
float: t_sulfate = 0.5;
float: t_ginger  = 0.75;

% Constraints
constraint sulfate >= 100;
constraint sulfate + ginger = 400;
constraint sulfate <= 2 * ginger;  % at most twice sulfate as ginger

% Total time (one added before the other => additive time)
var float: total_time = t_sulfate * sulfate + t_ginger * ginger;

solve minimize total_time;

output [
  "sulfate = ", show(sulfate), "\n",
  "ginger  = ", show(ginger), "\n",
  "total_time = ", show(total_time), " minutes\n"
];