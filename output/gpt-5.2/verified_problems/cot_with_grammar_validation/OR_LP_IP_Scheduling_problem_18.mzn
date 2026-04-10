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

var int: total_value;
var int: total_budget;
var int: total_persons;
var int: total_projects;

% Constraints
constraint total_value = sum(p in PROJECTS)(values[p] * x[p]);
constraint total_budget = sum(p in PROJECTS)(budgets[p] * x[p]);
constraint total_persons = sum(p in PROJECTS)(personell[p] * x[p]);
constraint total_projects = sum(p in PROJECTS)(x[p]);

constraint total_budget <= max_budget;
constraint total_persons <= max_persons;
constraint total_projects <= max_projects;

constraint forall(k in 1..num_not_with)(
  x[not_with[k,1]] + x[not_with[k,2]] <= 1
);

constraint forall(k in 1..num_requires)(
  x[requires[k,1]] = x[requires[k,2]]
);

% Objective
solve maximize total_value;