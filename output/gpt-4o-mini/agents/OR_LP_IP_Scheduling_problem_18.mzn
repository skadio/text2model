include "globals.mzn";

int: num_projects;                     % Number of projects
int: max_budget;                        % Budget limit
int: max_persons;                       % Number of persons available
int: max_projects;                      % Maximum number of projects that can be selected
array[1..num_projects] of int: values; % Values of each project
array[1..num_projects] of int: budgets; % Budgets of each project
array[1..num_projects] of int: personell; % Personnel required for each project

% Input for mutually exclusive projects and required projects
int: num_not_with;                     % Number of pairs of projects that cannot be selected together
array[1..num_not_with, 1..2] of int: not_with; % Pairs of projects that cannot be selected together

int: num_requires;                     % Number of pairs of projects that must be selected together
array[1..num_requires, 1..2] of int: requires; % Pairs of projects that must be selected together

% Decision variables
array[1..num_projects] of var 0..1: selected; % 1 if project is selected, 0 otherwise

% Constraints
constraint sum(selected) <= max_projects; % Limit on the number of projects selected
constraint sum(selected[i] * budgets[i] | i in 1..num_projects) <= max_budget; % Budget constraint
constraint sum(selected[i] * personell[i] | i in 1..num_projects) <= max_persons; % Personnel constraint

% Constraints for mutually exclusive projects
constraint forall(i in 1..num_not_with)(
    selected[not_with[i, 1]] + selected[not_with[i, 2]] <= 1
);

% Constraints for required projects
constraint forall(i in 1..num_requires)(
    selected[requires[i, 1]] = selected[requires[i, 2]]
);

% Objective: Maximize the total value of selected projects
var int: total_value = sum(selected[i] * values[i] | i in 1..num_projects);
solve maximize total_value;

% Output
output [ "Total Value = ", show(total_value), "\nSelected Projects = ", show(selected), "\n" ];