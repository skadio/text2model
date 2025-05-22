% Parameters
int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;
array[1..num_projects] of int: values;
array[1..num_projects] of int: budgets;
array[1..num_projects] of int: personell;
int: num_not_with;
int: num_requires;
array[1..num_not_with, 1..2] of int: not_with;
array[1..num_requires, 1..2] of int: requires;

% Variables
array[1..num_projects] of var 0..1: selected;

% Constraints
constraint sum(i in 1..num_projects)(selected[i]*budgets[i]) <= max_budget;
constraint sum(i in 1..num_projects)(selected[i]*personell[i]) <= max_persons;
constraint sum(i in 1..num_projects)(selected[i]) <= max_projects;

% Not with constraints
constraint forall(i in 1..num_not_with)(
    not(selected[not_with[i,1]] = 1 /\ selected[not_with[i,2]] = 1)
);

% Requires constraints
constraint forall(i in 1..num_requires)(
    (selected[requires[i,1]] = 1) <-> (selected[requires[i,2]] = 1)
);

% Objective
var int: total_value = sum(i in 1..num_projects)(selected[i]*values[i]);
solve maximize total_value;