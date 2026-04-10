% Parameters
int: num_projects;                 % Number of available projects
int: max_budget;                   % Total budget limit (million SEK)
int: max_persons;                  % Total available personnel (persons)
int: max_projects;                 % Max number of projects that can be selected

array[1..num_projects] of int: values;     % Project values (thousand SEK)
array[1..num_projects] of int: budgets;    % Project budgets (million SEK)
array[1..num_projects] of int: personell;  % Project personnel requirements

int: num_not_with;                 % Number of mutually-exclusive project pairs
array[1..num_not_with, 1..2] of int: not_with; % Each row: [project_i, project_j]

int: num_requires;                 % Number of requirement pairs
array[1..num_requires, 1..2] of int: requires; % Each row: [i, j] meaning i requires j

set of int: PROJECTS = 1..num_projects;    % Index set of projects


% Variables
array[PROJECTS] of var 0..1: select;       % 1 if project is selected, else 0

var 0..sum(values): total_value;           % Total selected value (thousand SEK)
var 0..sum(budgets): total_budget;         % Total selected budget (million SEK)
var 0..sum(personell): total_persons;      % Total selected personnel usage (persons)
var 0..num_projects: num_selected;         % Number of selected projects


% Constraints
% --- Link aggregate variables to selection decisions ---
constraint total_value   = sum(p in PROJECTS)(values[p]    * select[p]);
constraint total_budget  = sum(p in PROJECTS)(budgets[p]   * select[p]);
constraint total_persons = sum(p in PROJECTS)(personell[p] * select[p]);
constraint num_selected  = sum(p in PROJECTS)(select[p]);

% --- Resource limits (budget and personnel) ---
constraint total_budget  <= max_budget;
constraint total_persons <= max_persons;

% --- Limit on number of projects selected ---
constraint num_selected <= max_projects;

% --- Mutually exclusive project pairs ---
% For each (i,j) in not_with: cannot select both i and j
constraint
  forall(k in 1..num_not_with) (
    select[not_with[k,1]] + select[not_with[k,2]] <= 1
  );

% --- Requirement (dependency) pairs ---
% For each (i,j) in requires: if i is selected then j must be selected
constraint
  forall(k in 1..num_requires) (
    select[requires[k,1]] <= select[requires[k,2]]
  );


% Objective
solve maximize total_value;