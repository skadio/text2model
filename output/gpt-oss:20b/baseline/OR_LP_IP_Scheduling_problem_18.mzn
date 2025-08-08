int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;
int: num_not_with;
int: num_requires;

array[1..num_projects] of int: values;
array[1..num_projects] of int: budgets;
array[1..num_projects] of int: personell;

array[1..num_not_with, 1..2] of int: not_with;
array[1..num_requires, 1..2] of int: requires;

var bool: select[1..num_projects];

var int: max_value = sum(i in 1..num_projects) (select[i] * values[i]);

constraint sum(i in 1..num_projects) (select[i] * budgets[i]) <= max_budget;
constraint sum(i in 1..num_projects) (select[i] * personell[i]) <= max_persons;
constraint sum(i in 1..num_projects) select[i] <= max_projects;

constraint forall(k in 1..num_not_with) (
    select[not_with[k,1]] + select[not_with[k,2]] <= 1
);

constraint forall(k in 1..num_requires) (
    select[requires[k,1]] == select[requires[k,2]]
);

solve maximize max_value;

output [
    "Max value: ", show(max_value), "\n",
    "Selected projects: ", show([i | i in 1..num_projects where select[i]]), "\n"
];