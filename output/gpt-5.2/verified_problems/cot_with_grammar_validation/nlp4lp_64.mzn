% Parameters
int: I; % number of projects
int: J; % number of consultants

array[1..J] of int: FixedCosts;
array[1..I, 1..J] of int: AdditionalCosts;

int: MaxProjectsPerConsultant;

% Variables
array[1..J] of var bool: hire;                 % 1 if consultant j is hired
array[1..I, 1..J] of var bool: assign;         % 1 if project i assigned to consultant j

var int: TotalCost;

% Constraints
constraint forall(i in 1..I) (
  sum(j in 1..J)(bool2int(assign[i,j])) = 1
);

constraint forall(j in 1..J) (
  sum(i in 1..I)(bool2int(assign[i,j])) <= MaxProjectsPerConsultant
);

constraint forall(i in 1..I, j in 1..J) (
  bool2int(assign[i,j]) <= bool2int(hire[j])
);

constraint TotalCost =
  sum(j in 1..J)(FixedCosts[j] * bool2int(hire[j])) +
  sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * bool2int(assign[i,j]));

% Objective
solve minimize TotalCost;