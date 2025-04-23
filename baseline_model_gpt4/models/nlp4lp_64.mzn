include "globals.mzn";

% Number of projects
int: I;
% Number of consultants
int: J;
% Fixed cost for each consultant
array[1..J] of int: FixedCosts;
% Additional cost for assigning consultant i to project j
array[1..I, 1..J] of int: AdditionalCosts;
% Maximum number of projects that can be assigned to a consultant
int: MaxProjectsPerConsultant;

% Decision variable: assignment[i,j] is 1 if consultant j is assigned to project i, 0 otherwise
array[1..I, 1..J] of var 0..1: assignment;

% Objective: Minimize the total cost
var int: total_cost = sum(j in 1..J) (FixedCosts[j] * bool2int(sum(i in 1..I) (assignment[i,j]) > 0)) + sum(i in 1..I, j in 1..J) (AdditionalCosts[i,j] * assignment[i,j]);
minimize total_cost;

% Constraint: Each project is assigned to exactly one consultant
constraint forall(i in 1..I) (sum(j in 1..J) (assignment[i,j]) = 1);

% Constraint: A consultant can be assigned to at most MaxProjectsPerConsultant projects
constraint forall(j in 1..J) (sum(i in 1..I) (assignment[i,j]) <= MaxProjectsPerConsultant);

solve satisfy;
output [ "Total cost: " ++ show(total_cost) ++ "\n" ] ++
[ if fix(assignment[i,j]) = 1 then "Project " ++ show(i) ++ " is assigned to consultant " ++ show(j) ++ "\n" else "" endif | i in 1..I, j in 1..J ];