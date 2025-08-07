include "globals.mzn";

/* Input data */
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

/* Decision variables */
array[1..num_projects] of var 0..1: selected;

/* Budget, personnel and project‑count limits */
constraint sum(i in 1..num_projects) selected[i] * budgets[i] <= max_budget;
constraint sum(i in 1..num_projects) selected[i] * personell[i] <= max_persons;
constraint sum(i in 1..num_projects) selected[i] <= max_projects;

/* Projects that cannot be taken together */
constraint forall(i in 1..num_not_with)(
    selected[not_with[i,1]] + selected[not_with[i,2]] <= 1
);

/* Projects that must be taken together */
constraint forall(i in 1..num_requires)(
    selected[requires[i,1]] = selected[requires[i,2]]
);

/* Objective: maximise total value */
var int: total_value = sum(i in 1..num_projects) selected[i] * values[i];
solve maximize total_value;

/* Output */
output [
    "Selected projects: ", show([i | i in 1..num_projects where selected[i] = 1]), "\n",
    "Total value: ", show(total_value), "\n"
];