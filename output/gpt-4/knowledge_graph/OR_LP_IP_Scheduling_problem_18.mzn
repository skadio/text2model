include "globals.mzn";

% Parameters
int: num_projects; % Number of projects
int: max_budget; % Budget limit
int: max_persons; % Number of persons available
int: max_projects; % Maximum number of projects that can be selected
array[1..num_projects] of int: values; % Values of each project
array[1..num_projects] of int: budgets; % Budgets of each project
array[1..num_projects] of int: personell; % Personnel required for each project
array[1..num_not_with, 1..2] of int: not_with; % Projects that cannot be selected together
array[1..num_requires, 1..2] of int: requires; % Projects that must be selected together

% Variables
array[1..num_projects] of var 0..1: x; % Binary variable indicating whether a project is selected or not

% Constraints
constraint sum(i in 1..num_projects)(x[i]*budgets[i]) <= max_budget; % Budget constraint
constraint sum(i in 1..num_projects)(x[i]*personell[i]) <= max_persons; % Personnel constraint
constraint sum(i in 1..num_projects)(x[i]) <= max_projects; % Maximum number of projects constraint

% Projects that cannot be selected together
constraint forall(i in 1..num_not_with)(x[not_with[i,1]] + x[not_with[i,2]] <= 1);

% Projects that must be selected together
constraint forall(i in 1..num_requires)(x[requires[i,1]] = x[requires[i,2]]);

% Objective
var int: total_value = sum(i in 1..num_projects)(x[i]*values[i]);
solve maximize total_value;

% Output
output [ "Project " ++ show(i) ++ " selected: " ++ show(x[i]) | i in 1..num_projects];