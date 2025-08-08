% Parameters
int: I;
int: J;
array[1..J] of int: FixedCosts;
array[1..I, 1..J] of int: AdditionalCosts;
int: MaxProjectsPerConsultant;

% Variables
array[1..I, 1..J] of var 0..1: x;
array[1..J] of var 0..1: y;

% Constraints
constraint
  forall(j in 1..J) (
    y[j] = sum(i in 1..I)(x[i,j])
  );

constraint
  forall(i in 1..I) (
    sum(j in 1..J)(x[i,j]) <= 1
  );

constraint
  forall(j in 1..J) (
    sum(i in 1..I)(x[i,j]) <= MaxProjectsPerConsultant
  );

% Objective
solve minimize
  sum(j in 1..J)(FixedCosts[j] * y[j]) + sum(i in 1..I, j in 1..J)(AdditionalCosts[i,j] * x[i,j]);