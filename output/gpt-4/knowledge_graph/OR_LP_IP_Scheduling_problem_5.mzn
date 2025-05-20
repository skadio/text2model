include "globals.mzn";

% Parameters
int: rows; % Number of programmers
int: cols; % Number of jobs
array[1..rows, 1..cols] of int: cost; % Cost matrix

% Variables
array[1..rows, 1..cols] of var 0..1: x; % Assignment matrix

% Constraints
constraint forall(i in 1..rows)(sum(j in 1..cols)(x[i,j]) = 1); % Each programmer is assigned exactly one job
constraint forall(j in 1..cols)(sum(i in 1..rows)(x[i,j]) = 1); % Each job is assigned exactly one programmer

% Objective
var int: total_cost = sum(i in 1..rows, j in 1..cols)(cost[i,j]*x[i,j]);
solve minimize total_cost;

% Output
output [ "Total cost: " ++ show(total_cost) ++ "\n" ] ++
[ if fix(x[i,j]) = 1 then "Programmer " ++ show(i) ++ " is assigned to job " ++ show(j) ++ "\n" else "" endif | i in 1..rows, j in 1..cols ];