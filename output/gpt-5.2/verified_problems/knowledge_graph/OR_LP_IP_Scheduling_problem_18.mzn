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

array[PROJECTS] of var bool: x;

constraint sum(p in PROJECTS)(budgets[p] * bool2int(x[p])) <= max_budget;
constraint sum(p in PROJECTS)(personell[p] * bool2int(x[p])) <= max_persons;
constraint sum(p in PROJECTS)(bool2int(x[p])) <= max_projects;

constraint forall(k in 1..num_not_with) (
  bool2int(x[not_with[k,1]]) + bool2int(x[not_with[k,2]]) <= 1
);

constraint forall(k in 1..num_requires) (
  x[requires[k,1]] -> x[requires[k,2]]
);

var int: total_value = sum(p in PROJECTS)(values[p] * bool2int(x[p]));

solve maximize total_value;

output [
  "total_value=", show(total_value), "\n",
  "selected_projects=", show([p | p in PROJECTS where fix(x[p]) = true]), "\n",
  "used_budget=", show(sum(p in PROJECTS)(budgets[p] * bool2int(x[p]))), "\n",
  "used_persons=", show(sum(p in PROJECTS)(personell[p] * bool2int(x[p]))), "\n"
];