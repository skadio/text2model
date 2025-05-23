include "globals.mzn";

% Parameters
int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;
array[1..num_projects] of int: values;
array[1..num_projects] of int: budgets;
array[1..num_projects] of int: personell;
set of int: not_with;
set of int: requires;

% Decision variable
array[1..num_projects] of var 0..1: x; % 1 if project is selected, 0 otherwise

% Objective
var int: total_value;
constraint total_value = sum(i in 1..num_projects)(x[i]*values[i]);
solve maximize total_value;

% Constraints
constraint sum(i in 1..num_projects)(x[i]*budgets[i]) <= max_budget;
constraint sum(i in 1..num_projects)(x[i]*personell[i]) <= max_persons;
constraint sum(i in 1..num_projects)(x[i]) <= max_projects;

% Projects that cannot be selected together
constraint forall(i in 1..num_projects, j in i+1..num_projects)
    (if i in not_with /\ j in not_with then x[i] + x[j] <= 1 else true endif);

% Projects that must be selected together
constraint forall(i in 1..num_projects, j in i+1..num_projects)
    (if i in requires /\ j in requires then x[i] = x[j] else true endif);

% Output
output [ if fix(x[i]) = 1 then "Project " ++ show(i) ++ " is selected\n" else "" endif | i in 1..num_projects ];