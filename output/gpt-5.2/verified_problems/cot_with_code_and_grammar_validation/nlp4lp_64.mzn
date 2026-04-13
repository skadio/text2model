% Parameters
int: I;
int: J;

array[1..J] of int: FixedCosts;
array[1..I, 1..J] of int: AdditionalCosts;

int: MaxProjectsPerConsultant;

% Variables
array[1..I, 1..J] of var 0..1: x;   % 1 if project i assigned to consultant j
array[1..J] of var 0..1: hire;       % 1 if consultant j is hired

var int: total_cost;

% Constraints
constraint
  forall(i in 1..I) (
    sum(j in 1..J)(x[i,j]) = 1
  );

constraint
  forall(j in 1..J) (
    sum(i in 1..I)(x[i,j]) <= MaxProjectsPerConsultant
  );

constraint
  forall(i in 1..I, j in 1..J) (
    x[i,j] <= hire[j]
  );

constraint
  total_cost =
    sum(j in 1..J)(FixedCosts[j] * hire[j]) +
    sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * x[i,j]);

% Objective
solve minimize total_cost;