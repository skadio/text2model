% Parameters
int: num_skis; % Number of available skis
int: num_skiers; % Number of skiers
array[1..num_skis] of int: ski_heights; % Array of ski heights
array[1..num_skiers] of int: skier_heights; % Array of skier heights

% Variables
% Assignment of skis to skiers
array[1..num_skiers] of var 1..num_skis: ski_assignment;

% Constraints
% Each ski can be assigned to at most one skier
include "alldifferent.mzn";
constraint alldifferent(ski_assignment);

% Objective
% Minimize the sum of disparities between skier heights and ski heights
var int: total_disparity = sum(i in 1..num_skiers) (abs(skier_heights[i] - ski_heights[ski_assignment[i]]));
solve minimize total_disparity;