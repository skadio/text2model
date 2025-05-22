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
array[1..num_projects] of var bool: x;   % x[i] = true iff project i is selected

% Constraints
% Budget limit
constraint
    sum(i in 1..num_projects)(budgets[i] * bool2int(x[i])) <= max_budget;

% Personnel limit
constraint
    sum(i in 1..num_projects)(personell[i] * bool2int(x[i])) <= max_persons;

% Maximum number of projects
constraint
    sum(i in 1..num_projects)(bool2int(x[i])) <= max_projects;

% Projects that cannot be selected together
constraint
    forall(k in 1..num_not_with) (
        let {
            int: i = not_with[k,1],
            int: j = not_with[k,2]
        } in
            bool2int(x[i]) + bool2int(x[j]) <= 1
    );

% Projects that must be selected together
constraint
    forall(k in 1..num_requires) (
        let {
            int: i = requires[k,1],
            int: j = requires[k,2]
        } in
            x[i] = x[j]
    );

% Objective
solve maximize
    sum(i in 1..num_projects)(values[i] * bool2int(x[i]));