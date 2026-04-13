include "globals.mzn";

% ---------- Input data ----------
int: num_projects;
int: max_budget;
int: max_persons;
int: max_projects;

array[1..num_projects] of int: values;     % thousand SEK
array[1..num_projects] of int: budgets;    % million SEK
array[1..num_projects] of int: personell;  % persons

int: num_not_with;
array[1..num_not_with, 1..2] of int: not_with;

int: num_requires;
array[1..num_requires, 1..2] of int: requires;

% ---------- Decision variables ----------
array[1..num_projects] of var 0..1: x;  % x[i]=1 if project i is selected

% ---------- Constraints ----------
% Budget and personnel limits
constraint sum(i in 1..num_projects)(budgets[i] * x[i]) <= max_budget;
constraint sum(i in 1..num_projects)(personell[i] * x[i]) <= max_persons;

% Max number of selected projects (hint: count)
var 0..num_projects: n_selected;
constraint count(x, 1, n_selected);
constraint n_selected <= max_projects;

% Incompatibilities: not_with (a,b) means cannot both be selected
constraint forall(k in 1..num_not_with) (
  x[not_with[k,1]] + x[not_with[k,2]] <= 1
);

% Requirements: requires (a,b) means if a selected then b must be selected
constraint forall(k in 1..num_requires) (
  x[requires[k,1]] <= x[requires[k,2]]
);

% ---------- Objective ----------
var int: total_value = sum(i in 1..num_projects)(values[i] * x[i]);
solve maximize total_value;

% ---------- Output ----------
output [
  "total_value(thousand_SEK) = ", show(total_value), "\n",
  "n_selected = ", show(n_selected), "\n",
  "selected_projects = ", show([i | i in 1..num_projects where fix(x[i]) = 1]), "\n",
  "x = ", show(x), "\n",
  "total_budget(million_SEK) = ", show(sum(i in 1..num_projects)(budgets[i] * x[i])), "\n",
  "total_persons = ", show(sum(i in 1..num_projects)(personell[i] * x[i])), "\n"
];