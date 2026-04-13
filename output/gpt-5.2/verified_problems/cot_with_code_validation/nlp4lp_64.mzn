% Project–Consultant Assignment with Hiring Costs

% Parameters
int: I; % Number of projects
int: J; % Number of consultants
array[1..J] of int: FixedCosts;                % Fixed cost for hiring consultant j
array[1..I, 1..J] of int: AdditionalCosts;     % Cost of assigning project i to consultant j
int: MaxProjectsPerConsultant;

% Decision variables
array[1..J] of var 0..1: hire;                 % 1 if consultant j is hired
array[1..I, 1..J] of var 0..1: assign;         % 1 if project i is assigned to consultant j

% Constraints
constraint forall(i in 1..I) (
  sum(j in 1..J)(assign[i,j]) = 1
);

constraint forall(j in 1..J) (
  sum(i in 1..I)(assign[i,j]) <= MaxProjectsPerConsultant
);

constraint forall(i in 1..I, j in 1..J) (
  assign[i,j] <= hire[j]
);

% Objective: minimize total fixed + assignment costs
solve minimize
  sum(j in 1..J)(FixedCosts[j] * hire[j]) +
  sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * assign[i,j]);