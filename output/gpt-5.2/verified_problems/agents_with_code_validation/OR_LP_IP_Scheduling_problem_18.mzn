% Parameters
int: num_projects;                 % Number of candidate projects
set of int: PROJECTS = 1..num_projects;

int: max_budget;                   % Total budget limit (million SEK)
int: max_persons;                  % Total personnel available
int: max_projects;                 % Maximum number of projects that can be selected

array[PROJECTS] of int: values;    % Value per project (thousand SEK)
array[PROJECTS] of int: budgets;   % Budget per project (million SEK)
array[PROJECTS] of int: personell; % Personnel required per project

int: num_not_with;                 % Number of incompatible project pairs
array[1..num_not_with, 1..2] of int: not_with;   % Pairs (i,j) that cannot both be selected

int: num_requires;                 % Number of dependency pairs
array[1..num_requires, 1..2] of int: requires;   % Pairs (i,j) meaning i requires j


% Variables
array[PROJECTS] of var 0..1: select;     % 1 if project is selected, else 0

var 0..sum(values): total_value;         % Total value of selected projects
var 0..sum(budgets): total_budget;       % Total budget used
var 0..sum(personell): total_persons;    % Total personnel used

var 0..num_projects: num_selected;       % Number of selected projects


% Constraints

% Link aggregate variables to selection decisions
constraint total_value   = sum(p in PROJECTS)(values[p]    * select[p]);
constraint total_budget  = sum(p in PROJECTS)(budgets[p]   * select[p]);
constraint total_persons = sum(p in PROJECTS)(personell[p] * select[p]);
constraint num_selected  = sum(p in PROJECTS)(select[p]);

% Resource limits (budget and personnel)
constraint total_budget  <= max_budget;
constraint total_persons <= max_persons;

% Limit on number of projects selected
constraint num_selected <= max_projects;

% Incompatible projects: cannot select both projects in each pair
constraint
  forall(k in 1..num_not_with) (
    let {
      int: i = not_with[k,1],
      int: j = not_with[k,2]
    } in
      select[i] + select[j] <= 1
  );

% Dependency (requires): if i is selected then j must also be selected
constraint
  forall(k in 1..num_requires) (
    let {
      int: i = requires[k,1],
      int: j = requires[k,2]
    } in
      select[i] <= select[j]
  );


% Objective
solve maximize total_value;