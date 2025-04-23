% Parameters
int: I; % Number of projects
int: J; % Number of Consultants
array[1..J] of int: FixedCosts; % Fixed cost for project j
array[1..I, 1..J] of int: AdditionalCosts; % Additional cost for assigning consultant i to project j
int: MaxProjectsPerConsultant; % Maximum number of projects that can be assigned to a consultant

% Variables
array[1..I, 1..J] of var 0..1: Assign; % Binary variable indicating if consultant j is assigned to project i
array[1..J] of var 0..1: Hire; % Binary variable indicating if consultant j is hired

% Constraints

% Constraint 1: A consultant can only be assigned to a project if they are hired
constraint forall(i in 1..I, j in 1..J) (
  Assign[i,j] <= Hire[j]
);

% Constraint 2: Each project must be assigned to exactly one consultant
constraint forall(i in 1..I) (
  sum(j in 1..J) (Assign[i,j]) = 1
);

% Constraint 3: A consultant cannot be assigned more than the maximum number of projects
constraint forall(j in 1..J) (
  sum(i in 1..I) (Assign[i,j]) <= MaxProjectsPerConsultant
);

% Constraint 4: If a consultant is not hired, they cannot be assigned to any project
constraint forall(j in 1..J) (
  if Hire[j] = 0 then
    sum(i in 1..I) (Assign[i,j]) = 0
  endif
);

% Objective
solve minimize sum(j in 1..J) (Hire[j]*FixedCosts[j]) + sum(i in 1..I, j in 1..J) (Assign[i,j]*AdditionalCosts[i,j]);