% Parameters
int: num_projects;
set of int: PROJECTS = 1..num_projects;

int: max_budget;
int: max_persons;
int: max_projects;

array[PROJECTS] of int: values;
array[PROJECTS] of int: budgets;
array[PROJECTS] of int: personell;

int: num_not_with;
array[1..num_not_with, 1..2] of int: not_with;

int: num_requires;
array[1..num_requires, 1..2] of int: requires;

% Variables
array[PROJECTS] of var 0..1: x;
var 0..sum(values): total_value;

% Constraints
constraint
  sum(p in PROJECTS)(budgets[p] * x[p]) <= max_budget;

constraint
  sum(p in PROJECTS)(personell[p] * x[p]) <= max_persons;

constraint
  sum(p in PROJECTS)(x[p]) <= max_projects;

constraint
  forall(k in 1..num_not_with) (
    let {
      int: a = not_with[k,1],
      int: b = not_with[k,2]
    } in
      x[a] + x[b] <= 1
  );

constraint
  forall(k in 1..num_requires) (
    let {
      int: a = requires[k,1],
      int: b = requires[k,2]
    } in
      x[a] = x[b]
  );

constraint
  total_value = sum(p in PROJECTS)(values[p] * x[p]);

% Objective
solve maximize total_value;