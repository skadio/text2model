% Parameters
int: I; % Number of projects
int: J; % Number of Consultants
array[1..J] of int: FixedCosts; % Fixed cost for project j
array[1..I, 1..J] of int: AdditionalCosts; % Additional cost for assigning consultant i to project j
int: MaxProjectsPerConsultant; % Maximum number of projects that can be assigned to a consultant

% Variables
array[1..I, 1..J] of var 0..1: Assign; % Assignment of consultants to projects
array[1..J] of var 0..1: Hire; % Whether to hire a consultant or not

% Constraints
constraint forall(j in 1..J) (
    sum(i in 1..I) (Assign[i,j]) <= MaxProjectsPerConsultant * Hire[j]
);

constraint forall(j in 1..J) (
    sum(i in 1..I) (Assign[i,j]) >= Hire[j]
);

% Objective
var int: TotalCost = sum(j in 1..J) (FixedCosts[j] * Hire[j]) + sum(i in 1..I, j in 1..J) (AdditionalCosts[i,j] * Assign[i,j]);
solve minimize TotalCost;