% Parameters
int: num_skis; % Number of available skis
int: num_skiers; % Number of skiers
array[1..num_skis] of int: ski_heights; % Array of ski heights
array[1..num_skiers] of int: skier_heights; % Array of skier heights

% Variables
% Assignment of skis to skiers. ski_assignment[i] represents the ski assigned to the i-th skier.
array[1..num_skiers] of var 1..num_skis: ski_assignment; 

% Constraints

% Each ski can be assigned to at most one skier
constraint forall(i in 1..num_skis) (
  sum(j in 1..num_skiers)(bool2int(ski_assignment[j] = i)) <= 1
);

% The number of skis assigned should be equal to the number of skiers
constraint sum(i in 1..num_skiers)(bool2int(ski_assignment[i] >= 1)) = num_skiers;

% The disparity between the height of the skier and the height of the assigned ski should be minimized
% This is represented as a soft constraint using an auxiliary variable 'disparity'
array[1..num_skiers] of var int: disparity;
constraint forall(i in 1..num_skiers) (
  disparity[i] = abs(skier_heights[i] - ski_heights[ski_assignment[i]])
);

% Objective
solve minimize sum(i in 1..num_skiers)(disparity[i]);