% Resource allocation optimization for sports team
% Minimize total cost score:
%   5 per training hour, 3 per equipment unit, 2 per nutrition unit
% Subject to:
%   training + equipment <= 50
%   training + nutrition >= 30
%   |equipment - nutrition| <= 10
% Variables are whole numbers.

var 0..100: training;
var 0..100: equipment;
var 0..100: nutrition;

constraint training + equipment <= 50;
constraint training + nutrition >= 30;
constraint abs(equipment - nutrition) <= 10;

var int: total_cost = 5*training + 3*equipment + 2*nutrition;

solve minimize total_cost;

output [
  "minimum_total_cost_score = ", show(total_cost), "\n",
  "training = ", show(training), "\n",
  "equipment = ", show(equipment), "\n",
  "nutrition = ", show(nutrition), "\n"
];