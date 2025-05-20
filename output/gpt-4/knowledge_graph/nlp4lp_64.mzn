% Input parameters
int: I; % Number of projects
int: J; % Number of Consultants
array[1..J] of int: FixedCosts; % Fixed cost for project j
array[1..I, 1..J] of int: AdditionalCosts; % Additional cost for assigning consultant i to project j
int: MaxProjectsPerConsultant; % Maximum number of projects that can be assigned to a consultant

% Decision variables
array[1..I, 1..J] of var 0..1: assign; % assign[i,j] = 1 if consultant j is assigned to project i, 0 otherwise

% Objective function
var int: total_cost = sum(i in 1..I, j in 1..J) (assign[i,j] * AdditionalCosts[i,j]) + sum(j in 1..J) (FixedCosts[j]);
minimize total_cost;

% Constraints
constraint forall(j in 1..J) (sum(i in 1..I) (assign[i,j]) <= MaxProjectsPerConsultant);
constraint forall(i in 1..I) (sum(j in 1..J) (assign[i,j]) = 1);

solve satisfy;
output [ "Total cost: " ++ show(total_cost) ++ "\n" ];