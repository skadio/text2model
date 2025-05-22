% Parameters
int: num_people;
array[1..num_people, 1..num_people] of 0..1: compatible;

% Variables
array[1..num_people, 1..num_people] of var 0..1: x;

% Constraints
constraint
  forall(i in 1..num_people) (
    x[i,i] = 0
  );

constraint
  forall(i in 1..num_people, j in 1..num_people) (
    x[i,j] <= compatible[i,j]
  );

constraint
  forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i,j]) <= 1
  );

constraint
  forall(j in 1..num_people) (
    sum(i in 1..num_people)(x[i,j]) <= 1
  );

constraint
  forall(k in 1..num_people) (
    sum(j in 1..num_people)(x[k,j]) = sum(i in 1..num_people)(x[i,k])
  );

% Objective
solve maximize sum(i in 1..num_people, j in 1..num_people)(x[i,j]);