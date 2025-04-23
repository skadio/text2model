include "globals.mzn";

% Number of programmers
int: rows;

% Number of jobs
int: cols;

% Cost matrix where each cell represents the preference value of the programmer for the job
array[1..rows, 1..cols] of int: cost;

% Binary matrix representing the assignment of programmers to jobs
array[1..rows, 1..cols] of var 0..1: x;

% Objective function to minimize the sum of preferences
var int: total_cost = sum(i in 1..rows, j in 1..cols) (cost[i,j]*x[i,j]);

% Each programmer is assigned to exactly one job
constraint forall(i in 1..rows) (sum(j in 1..cols) (x[i,j]) = 1);

% Each job is assigned to exactly one programmer
constraint forall(j in 1..cols) (sum(i in 1..rows) (x[i,j]) = 1);

% Minimize the total cost
solve minimize total_cost;

% Output the assignment and the total cost
output [ "Assignment: " ] ++
       [ if fix(x[i,j]) = 1 then "Programmer " ++ show(i) ++ " is assigned to job " ++ show(j) ++ "\n" else "" endif | i in 1..rows, j in 1..cols ] ++
       [ "Total cost: " ++ show(total_cost) ];