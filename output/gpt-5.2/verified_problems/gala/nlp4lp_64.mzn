include "globals.mzn";

%-------------------------
% Input data (from .dzn)
%-------------------------
int: I;  % number of projects
int: J;  % number of consultants

array[1..J] of int: FixedCosts;              % fixed cost if consultant j is used
array[1..I, 1..J] of int: AdditionalCosts;   % cost of assigning project i to consultant j
int: MaxProjectsPerConsultant;

%-------------------------
% Decision variables
%-------------------------
% assign[i,j] = 1 if project i is assigned to consultant j
array[1..I, 1..J] of var 0..1: assign;

% used[j] = 1 if consultant j is hired/used for at least one project
array[1..J] of var 0..1: used;

%-------------------------
% Constraints
%-------------------------

% Each project must be assigned to exactly one consultant
constraint forall(i in 1..I)(
  sum(j in 1..J)(assign[i,j]) = 1
);

% Consultant capacity and linking to "used"
constraint forall(j in 1..J)(
  let { var 0..I: load = sum(i in 1..I)(assign[i,j]) }
  in
    load <= MaxProjectsPerConsultant /\
    load <= I * used[j] /\
    load >= used[j]
);

%-------------------------
% Objective: minimize total cost
%-------------------------
var int: totalCost =
  sum(j in 1..J)(FixedCosts[j] * used[j]) +
  sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * assign[i,j]);

solve minimize totalCost;

%-------------------------
% Output
%-------------------------
output [
  "TotalCost = ", show(totalCost), "\n",
  "Used = ", show(used), "\n",
  "Assignment (project -> consultant):\n",
  concat([
    "Project " ++ show(i) ++ " -> " ++
    show(sum(j in 1..J)(j * fix(assign[i,j]))) ++ "\n"
    | i in 1..I
  ]),
  "Assign matrix (I x J):\n", show(assign), "\n"
];