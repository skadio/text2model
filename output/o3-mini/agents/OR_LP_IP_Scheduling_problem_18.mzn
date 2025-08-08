include "globals.mzn";

% Data parameters provided via .dzn file
int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;

array[1..num_projects] of int: values;       % value (in thousand SEK)
array[1..num_projects] of int: budgets;       % budget requirement (in million SEK)
array[1..num_projects] of int: personell;      % personnel requirement

int: num_not_with; 
array[1..num_not_with, 1..2] of int: not_with; % pairs of projects that cannot be selected together

int: num_requires;
array[1..num_requires, 1..2] of int: requires; % pairs of projects that must be selected together

% Decision variables: 1 if project is selected, 0 otherwise.
array[1..num_projects] of var 0..1: selected;

% Count the number of selected projects and limit them
var 0..num_projects: num_selected;
constraint count(selected, 1, num_selected);
constraint num_selected <= max_projects;

% Budget constraint: total budget used by selected projects must not exceed max_budget.
constraint sum(i in 1..num_projects)( selected[i] * budgets[i] ) <= max_budget;

% Personnel constraint: total persons required must not exceed max_persons.
constraint sum(i in 1..num_projects)( selected[i] * personell[i] ) <= max_persons;

% Mutual exclusion: for each pair in not_with, at most one project can be selected.
constraint forall(r in 1..num_not_with)(
    selected[ not_with[r,1] ] + selected[ not_with[r,2] ] <= 1
);

% Projects that must be selected together: both have the same selection value.
constraint forall(r in 1..num_requires)(
    selected[ requires[r,1] ] = selected[ requires[r,2] ]
);

% Define the total value of selected projects.
var int: total_value = sum(i in 1..num_projects)( selected[i] * values[i] );

% Solve: maximize the total value.
solve maximize total_value;

% Output the decision and the total value.
output [
  "Selected projects: ", show(selected), "\n",
  "Total Value: ", show(total_value), "\n"
];