include "globals.mzn";

% --- data -------------------------------------------------------------
int: I;                                 % number of projects
int: J;                                 % number of consultants
array[1..J] of int: FixedCosts;         % fixed cost for hiring consultant j
array[1..I, 1..J] of int: AdditionalCosts; % cost for assigning project i to consultant j
int: MaxProjectsPerConsultant;          % maximum projects per consultant

% --- decision variables -----------------------------------------------
array[1..I] of var 1..J: assignment;           % consultant chosen for each project
array[1..J] of int: values = [1..J];           % possible consultant indices
array[1..J] of int: max_counts = [MaxProjectsPerConsultant | j in 1..J];
array[1..J] of var 0..I: counts;               % number of projects per consultant
array[1..J] of var bool: hired;                % hired(j) = true iff consultant j is used

% --- constraints ------------------------------------------------------
% Count how many times each consultant appears in the assignment
constraint global_cardinality(assignment, values, counts);
% Respect the maximum number of projects per consultant
constraint forall(j in values)(counts[j] <= max_counts[j]);

% Link hiring decision to counts
constraint forall(j in values)(
    (counts[j] >= 1) <-> hired[j]
);

% --- objective -------------------------------------------------------
var int: totalCost;
constraint totalCost == 
    sum(j in 1..J)(hired[j] * FixedCosts[j]) + 
    sum(i in 1..I)(AdditionalCosts[i, assignment[i]]);

solve minimize totalCost;

% --- output ----------------------------------------------------------
output [
    "Assignment per project: ", show(assignment), "\n",
    "Hired consultants:     ", show(hired), "\n",
    "Counts per consultant: ", show(counts), "\n",
    "Total cost:            ", show(totalCost), "\n"
];