% Knapsack (investment) problem

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

% Decision variables
array[PROJECTS] of var bool: x;

% Constraints
constraint sum(p in PROJECTS)(budgets[p] * bool2int(x[p])) <= max_budget;
constraint sum(p in PROJECTS)(personell[p] * bool2int(x[p])) <= max_persons;
constraint sum(p in PROJECTS)(bool2int(x[p])) <= max_projects;

constraint forall(k in 1..num_not_with) (
  let {
    int: a = not_with[k, 1],
    int: b = not_with[k, 2]
  } in
    bool2int(x[a]) + bool2int(x[b]) <= 1
);

% "Must be selected together" (interpreted as equivalence)
constraint forall(k in 1..num_requires) (
  let {
    int: a = requires[k, 1],
    int: b = requires[k, 2]
  } in
    x[a] <-> x[b]
);

% Objective
var int: total_value = sum(p in PROJECTS)(values[p] * bool2int(x[p]));

solve maximize total_value;

output [
  "total_value=", show(total_value), "\n",
  "selected=", show([p | p in PROJECTS where fix(bool2int(x[p])) = 1]), "\n"
];