% Parameters
int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;

array[1..num_projects] of int: values;
array[1..num_projects] of int: budgets;
array[1..num_projects] of int: personell;

int: num_not_with;
array[1..num_not_with, 1..2] of int: not_with;

int: num_requires;
array[1..num_requires, 1..2] of int: requires;

% Variables
array[1..num_projects] of var 0..1: select;

% Constraints
% Budget limit
constraint
    sum(i in 1..num_projects)(budgets[i] * select[i]) <= max_budget;

% Personnel limit
constraint
    sum(i in 1..num_projects)(personell[i] * select[i]) <= max_persons;

% Maximum number of projects that can be selected
constraint
    sum(i in 1..num_projects)(select[i]) <= max_projects;

% Incompatibility constraints (projects that cannot be selected together)
constraint
    forall(p in 1..num_not_with) (
        let { int: i = not_with[p,1];
              int: j = not_with[p,2]; } in
        select[i] + select[j] <= 1
    );

% Requirement constraints (projects that must be selected together)
constraint
    forall(p in 1..num_requires) (
        let { int: i = requires[p,1];
              int: j = requires[p,2]; } in
        select[i] == select[j]
    );

% Objective
var int: total_value = sum(i in 1..num_projects)(values[i] * select[i]);

solve maximize total_value;