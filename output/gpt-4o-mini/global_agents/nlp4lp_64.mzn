int: I;  % Number of projects
int: J;  % Number of consultants
array[1..J] of int: FixedCosts;  % Fixed cost for each consultant
array[1..I, 1..J] of int: AdditionalCosts;  % Additional costs for assigning consultants to projects
int: MaxProjectsPerConsultant;  % Maximum number of projects per consultant

% Decision variables
array[1..I, 1..J] of var 0..1: assignment;  % 1 if consultant j is assigned to project i, 0 otherwise
array[1..J] of var 0..MaxProjectsPerConsultant: projectCount;  % Count of projects assigned to each consultant

% Constraints
% Each project must be assigned to exactly one consultant
constraint forall(i in 1..I)(
    sum(j in 1..J)(assignment[i, j]) == 1
);

% Count the number of projects assigned to each consultant
constraint forall(j in 1..J)(
    projectCount[j] = sum(i in 1..I)(assignment[i, j])
);

% Each consultant can be assigned to a maximum number of projects
constraint forall(j in 1..J)(
    projectCount[j] <= MaxProjectsPerConsultant
);

% Objective: Minimize total cost
var int: totalCost = sum(i in 1..I, j in 1..J)(assignment[i, j] * (FixedCosts[j] + AdditionalCosts[i, j]));

solve minimize totalCost;

% Output
output [
    "Total Cost = ", show(totalCost), "\n",
    "Assignment = ", show(assignment), "\n"
];