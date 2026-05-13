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
array[1..num_projects] of var bool: selected;

% Constraints
constraint
  sum(i in 1..num_projects) (selected[i] * budgets[i]) <= max_budget /\
  sum(i in 1..num_projects) (selected[i] * personell[i]) <= max_persons /\
  sum(i in 1..num_projects) (selected[i]) <= max_projects;

constraint
  forall(k in 1..num_not_with) (
    selected[not_with[k,1]] + selected[not_with[k,2]] <= 1
  );

constraint
  forall(k in 1..num_requires) (
    selected[requires[k,1]] <= selected[requires[k,2]]
  );

% Objective
solve maximize
  sum(i in 1..num_projects) (selected[i] * values[i]);