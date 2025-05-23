% Parameters
int: num_skis; % Number of available skis
int: num_skiers; % Number of skiers
array[1..num_skis] of int: ski_heights; % Array of ski heights
array[1..num_skiers] of int: skier_heights; % Array of skier heights

% Variables
array[1..num_skiers] of var 1..num_skis: ski_assignment; % Assignment of skis to skiers

% Constraints
include "alldifferent.mzn"; % All skiers must have different skis
constraint alldifferent(ski_assignment);

% Objective
var int: total_disparity = sum(i in 1..num_skiers) (abs(ski_heights[ski_assignment[i]] - skier_heights[i]));
solve minimize total_disparity;

% Output
output [ "Total disparity: ", show(total_disparity), "\n",
         "Ski assignments: ", show(ski_assignment), "\n" ];