% Parameters
int: I; % Number of projects
int: J; % Number of Consultants
array[1..J] of int: FixedCosts; % Fixed cost for hiring consultant j
array[1..I, 1..J] of int: AdditionalCosts; % Additional cost for assigning consultant j to project i
int: MaxProjectsPerConsultant; % Maximum number of projects that can be assigned to a consultant

% Variables
% Assignment of consultants to projects
% 1 if consultant j is assigned to project i, 0 otherwise
array[1..I, 1..J] of var 0..1: assignment; 

% Constraints

% Each project should be assigned to exactly one consultant
constraint forall(i in 1..I) (
  sum(j in 1..J) (assignment[i,j]) = 1
);

% The number of projects assigned to a consultant should not exceed the maximum limit
constraint forall(j in 1..J) (
  sum(i in 1..I) (assignment[i,j]) <= MaxProjectsPerConsultant
);

% Objective
solve minimize sum(i in 1..I, j in 1..J) (assignment[i,j] * AdditionalCosts[i,j]) + sum(j in 1..J) (FixedCosts[j] * bool2int(sum(i in 1..I) (assignment[i,j]) > 0));