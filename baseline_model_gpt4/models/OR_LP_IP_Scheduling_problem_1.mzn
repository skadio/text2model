include "globals.mzn";

% Input parameters
int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% Decision variables
array[1..num_skiers, 1..num_skis] of var 0..1: assign;

% Each skier gets exactly one pair of skis
constraint forall(i in 1..num_skiers) (
  sum(j in 1..num_skis) (assign[i,j]) = 1
);

% Each pair of skis is assigned to at most one skier
constraint forall(j in 1..num_skis) (
  sum(i in 1..num_skiers) (assign[i,j]) <= 1
);

% Objective function to minimize the total disparity
var int: total_disparity = sum(i in 1..num_skiers, j in 1..num_skis) (
  assign[i,j] * abs(skier_heights[i] - ski_heights[j])
);

% Solve the problem
solve minimize total_disparity;

% Output the solution
output [ if fix(assign[i,j]) = 1 then "Skier " ++ show(i) ++ " gets skis of height " ++ show(ski_heights[j]) ++ "\n" else "" endif | i in 1..num_skiers, j in 1..num_skis ];