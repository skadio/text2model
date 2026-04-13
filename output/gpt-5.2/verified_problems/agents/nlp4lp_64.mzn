% Parameters
int: I; % Number of projects
int: J; % Number of consultants

set of int: Projects = 1..I;      % Project index set
set of int: Consultants = 1..J;   % Consultant index set

array[Consultants] of int: FixedCosts;                 % Fixed hiring cost for consultant j
array[Projects, Consultants] of int: AdditionalCosts;  % Extra cost for assigning project i to consultant j

int: MaxProjectsPerConsultant; % Max number of projects assignable to any consultant


% Variables
array[Projects, Consultants] of var 0..1: assign; % assign[i,j] = 1 if project i is assigned to consultant j
array[Consultants] of var 0..1: hire;             % hire[j] = 1 if consultant j is used (hired)


% Constraints

% Each project must be assigned to exactly one consultant
constraint
  forall(i in Projects) (
    sum(j in Consultants)(assign[i, j]) = 1
  );

% Consultant capacity: no consultant can be assigned more than MaxProjectsPerConsultant projects
constraint
  forall(j in Consultants) (
    sum(i in Projects)(assign[i, j]) <= MaxProjectsPerConsultant
  );

% Linking assignment to hiring: can only assign projects to a consultant if they are hired
constraint
  forall(i in Projects, j in Consultants) (
    assign[i, j] <= hire[j]
  );

% Strengthened linking: if a consultant is hired, they must have at least one assigned project
constraint
  forall(j in Consultants) (
    sum(i in Projects)(assign[i, j]) >= hire[j]
  );


% Objective
solve minimize
  sum(j in Consultants)(FixedCosts[j] * hire[j]) +
  sum(i in Projects, j in Consultants)(AdditionalCosts[i, j] * assign[i, j]);