int: I; % number of projects
int: J; % number of consultants

set of int: Projects = 1..I;
set of int: Consultants = 1..J;

array[Consultants] of int: FixedCosts; % fixed cost to hire/use consultant j
array[Projects, Consultants] of int: AdditionalCosts; % cost assigning project i to consultant j
int: MaxProjectsPerConsultant;

array[Projects, Consultants] of var 0..1: x; % 1 if project i assigned to consultant j
array[Consultants] of var 0..1: y; % 1 if consultant j is hired/used

% Each project assigned to exactly one consultant
constraint
  forall(i in Projects) (
    sum(j in Consultants)(x[i,j]) = 1
  );

% Capacity per consultant
constraint
  forall(j in Consultants) (
    sum(i in Projects)(x[i,j]) <= MaxProjectsPerConsultant
  );

% Linking: can only assign projects to hired/used consultants
constraint
  forall(i in Projects, j in Consultants) (
    x[i,j] <= y[j]
  );

var int: TotalCost =
  sum(j in Consultants)(FixedCosts[j] * y[j]) +
  sum(i in Projects, j in Consultants)(AdditionalCosts[i,j] * x[i,j]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "y (consultants used) = ", show(y), "\n",
  "x (assignment matrix) =\n",
  concat([ concat([ if fix(x[i,j]) = 1 then "1 " else "0 " endif | j in Consultants]) ++ "\n"
         | i in Projects ])
];