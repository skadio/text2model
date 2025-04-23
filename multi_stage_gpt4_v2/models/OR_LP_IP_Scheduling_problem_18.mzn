% Parameters
int: num_projects; % Number of projects to select from
int: max_budget; % Budget limit in million Swedish kronor
int: max_persons; % Number of persons available
int: max_projects; % Maximum number of projects that can be selected
array[1..num_projects] of int: values; % Values of each project in thousand Swedish kronor
array[1..num_projects] of int: budgets; % Budgets of each project in million Swedish kronor
array[1..num_projects] of int: personell; % Personnel required for each project
int: num_not_with; % Number of projects that cannot be selected together
array[1..num_not_with, 1..2] of int: not_with; % Projects that cannot be selected together
int: num_requires; % Number of projects that must be selected together
array[1..num_requires, 1..2] of int: requires; % Projects that must be selected together

% Variables
array[1..num_projects] of var 0..1: project_selection; % Binary variable indicating whether a project is selected or not

% Constraints

% The total budget of the selected projects should not exceed the maximum budget
constraint sum(i in 1..num_projects)(budgets[i]*project_selection[i]) <= max_budget;

% The total personnel required for the selected projects should not exceed the maximum number of persons available
constraint sum(i in 1..num_projects)(personell[i]*project_selection[i]) <= max_persons;

% The number of selected projects should not exceed the maximum number of projects that can be selected
constraint sum(i in 1..num_projects)(project_selection[i]) <= max_projects;

% If a project is selected, all the projects that must be selected with it should also be selected
constraint forall(i in 1..num_requires)( 
    project_selection[requires[i,1]] = 1 -> project_selection[requires[i,2]] = 1
);

% If a project is selected, all the projects that cannot be selected with it should not be selected
constraint forall(i in 1..num_not_with)( 
    project_selection[not_with[i,1]] = 1 -> project_selection[not_with[i,2]] = 0
);

% Objective
solve maximize sum(i in 1..num_projects)(values[i]*project_selection[i]);