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

set of int: PROJECTS = 1..num_projects;

% Variables
array[PROJECTS] of var 0..1: selected;

var 0..sum(values) : total_value = sum(i in PROJECTS)(values[i] * selected[i]);

% Constraints
% Budget limit
constraint
    sum(i in PROJECTS)(budgets[i] * selected[i]) <= max_budget;

% Personnel limit
constraint
    sum(i in PROJECTS)(personell[i] * selected[i]) <= max_persons;

% Maximum number of projects
constraint
    sum(i in PROJECTS)(selected[i]) <= max_projects;

% Projects that cannot be selected together
constraint
    forall(p in 1..num_not_with)(
        selected[not_with[p,1]] + selected[not_with[p,2]] <= 1
    );

% Projects that must be selected together
constraint
    forall(r in 1..num_requires)(
        selected[requires[r,1]] == selected[requires[r,2]]
    );

% Objective
solve maximize total_value;