% Parameters
int: num_people;
array2d(1..num_people, 1..num_people, int) compatible;

% Variables
array2d(1..num_people, 1..num_people, var bool) x;

% Constraints
constraint
  % Each person donates at most one kidney
  forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i][j]) <= 1
  ) /\
  % Each person receives at most one kidney
  forall(j in 1..num_people) (
    sum(i in 1..num_people)(x[i][j]) <= 1
  ) /\
  % Compatibility constraint
  forall(i in 1..num_people, j in 1..num_people) (
    x[i][j] <= compatible[i][j]
  ) /\
  % Donor must also receive a kidney
  forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i][j]) <= sum(k in 1..num_people)(x[k][i])
  );

% Objective
solve maximize
  sum(i in 1..num_people, j in 1..num_people)(x[i][j]);