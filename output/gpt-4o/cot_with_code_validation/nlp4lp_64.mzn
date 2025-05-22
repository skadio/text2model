% Parameters
int: I;
int: J;
set of int: Projects = 1..I;
set of int: Consultants = 1..J;

array[Consultants] of int: FixedCosts;
array[Projects, Consultants] of int: AdditionalCosts;
int: MaxProjectsPerConsultant;

% Variables
array[Projects, Consultants] of var 0..1: x;   % x[i,j] = 1 if project i assigned to consultant j
array[Consultants] of var 0..1: y;             % y[j] = 1 if consultant j is hired

% Constraints
constraint
  forall(i in Projects)(
    sum(j in Consultants)(x[i,j]) = 1
  );

constraint
  forall(j in Consultants)(
    sum(i in Projects)(x[i,j]) <= MaxProjectsPerConsultant
  );

constraint
  forall(i in Projects, j in Consultants)(
    x[i,j] <= y[j]
  );

% Objective
var int: total_fixed       = sum(j in Consultants)(FixedCosts[j] * y[j]);
var int: total_additional  = sum(i in Projects, j in Consultants)(AdditionalCosts[i,j] * x[i,j]);
var int: total_cost        = total_fixed + total_additional;

solve minimize total_cost;