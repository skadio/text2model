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
array[1..num_projects] of var 0..1: x; % Binary variable indicating if a project is selected

% Constraints
constraint sum(i in 1..num_projects)(x[i]*budgets[i]) <= max_budget; % Budget constraint
constraint sum(i in 1..num_projects)(x[i]*personell[i]) <= max_persons; % Personnel constraint
constraint sum(i in 1..num_projects)(x[i]) <= max_projects; % Maximum number of projects constraint

% Projects that cannot be selected together
constraint forall(i in 1..num_not_with)(
  x[not_with[i,1]] + x[not_with[i,2]] <= 1
);

% Projects that must be selected together
constraint forall(i in 1..num_requires)(
  x[requires[i,1]] = x[requires[i,2]]
);

% Objective
var int: total_value = sum(i in 1..num_projects)(x[i]*values[i]);
solve maximize total_value;