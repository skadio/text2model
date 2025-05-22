% Parameters
int: num_skis; % Number of available skis
int: num_skiers; % Number of skiers
array[1..num_skis] of int: ski_heights; % Array of ski heights
array[1..num_skiers] of int: skier_heights; % Array of skier heights

% Variables
array[1..num_skiers, 1..num_skis] of var 0..1: assign; % Assignment of skis to skiers

% Constraints
% Each skier gets exactly one ski
constraint forall(i in 1..num_skiers)(sum(j in 1..num_skis)(assign[i,j]) = 1);

% Each ski is assigned to exactly one skier
constraint forall(j in 1..num_skis)(sum(i in 1..num_skiers)(assign[i,j]) = 1);

% Objective
% Minimize the sum of disparities
var int: total_disparity = sum(i in 1..num_skiers, j in 1..num_skis)(assign[i,j] * abs(ski_heights[j] - skier_heights[i]));
solve minimize total_disparity;