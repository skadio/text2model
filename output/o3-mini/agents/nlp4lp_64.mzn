include "globals.mzn";

% Data
int: I;                                    % Number of projects
int: J;                                    % Number of consultants
int: MaxProjectsPerConsultant;             % Maximum projects a consultant can be assigned
array[1..J] of int: FixedCosts;            % Fixed cost for each consultant
array[1..I, 1..J] of int: AdditionalCosts; % Additional cost for assigning project i to consultant j

% Decision variables
% assignment[i] is the consultant (from 1 to J) assigned to project i
array[1..I] of var 1..J: assignment;

% used[j] is a binary variable: 1 if consultant j is hired (at least one project assigned), 0 otherwise.
array[1..J] of var 0..1: used;

% Enforce the maximum number of projects per consultant using global cardinality.
array[1..J] of int: lo = [0 | j in 1..J];
array[1..J] of int: up = [MaxProjectsPerConsultant | j in 1..J];
constraint global_cardinality_low_up(assignment, 1..J, lo, up);

% Link the used array with the assignment.
% A consultant j is used (used[j] = 1) if and only if at least one project is assigned to j.
constraint forall(j in 1..J)(
  used[j] = bool2int( exists(i in 1..I)( assignment[i] = j ) )
);

% Total cost: fixed cost for hiring consultants + additional assignment cost.
var int: totalCost = 
      sum(j in 1..J)( FixedCosts[j] * used[j] )
    + sum(i in 1..I)( AdditionalCosts[i, assignment[i]] );

solve minimize totalCost;

output [
  "Assignment = ", show(assignment), "\n",
  "Consultants used = ", show(used), "\n",
  "Total cost = ", show(totalCost), "\n"
];