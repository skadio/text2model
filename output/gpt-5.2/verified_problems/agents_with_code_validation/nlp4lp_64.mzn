% Parameters
int: I; % Number of projects
int: J; % Number of consultants

set of int: PROJECTS = 1..I;
set of int: CONSULTANTS = 1..J;

array[CONSULTANTS] of int: FixedCosts;                 % Fixed hiring cost for consultant j
array[PROJECTS, CONSULTANTS] of int: AdditionalCosts;  % Additional cost if project i is assigned to consultant j

int: MaxProjectsPerConsultant; % Max number of projects assignable to any consultant

% Variables
array[PROJECTS, CONSULTANTS] of var 0..1: assign; % assign[i,j]=1 if project i is assigned to consultant j
array[CONSULTANTS] of var 0..1: hire;             % hire[j]=1 if consultant j is hired/used
var int: total_cost;                              % Total cost (fixed + additional)

% Constraints

% Each project must be assigned to exactly one consultant
constraint
  forall(i in PROJECTS) (
    sum(j in CONSULTANTS)(assign[i,j]) = 1
  );

% A project can only be assigned to a consultant if that consultant is hired
constraint
  forall(i in PROJECTS, j in CONSULTANTS) (
    assign[i,j] <= hire[j]
  );

% Limit the number of projects assigned to each consultant
constraint
  forall(j in CONSULTANTS) (
    sum(i in PROJECTS)(assign[i,j]) <= MaxProjectsPerConsultant
  );

% Define total cost as fixed hiring costs plus additional assignment costs
constraint
  total_cost =
    sum(j in CONSULTANTS)(FixedCosts[j] * hire[j]) +
    sum(i in PROJECTS, j in CONSULTANTS)(AdditionalCosts[i,j] * assign[i,j]);

% Objective
solve minimize total_cost;