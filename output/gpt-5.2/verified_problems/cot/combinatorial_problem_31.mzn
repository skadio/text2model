% Parameters
int: num_people;
array[1..num_people, 1..num_people] of bool: compatible;

% Variables
array[1..num_people, 1..num_people] of var 0..1: x; % x[i,j]=1 if i donates to j

% Constraints
constraint
  forall(i in 1..num_people, j in 1..num_people) (
    x[i,j] <= bool2int(compatible[i,j])
  );

constraint
  forall(i in 1..num_people) (
    x[i,i] = 0
  );

% Each person donates exactly once
constraint
  forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i,j]) = 1
  );

% Each person receives exactly once
constraint
  forall(j in 1..num_people) (
    sum(i in 1..num_people)(x[i,j]) = 1
  );

% Objective
solve maximize sum(i in 1..num_people, j in 1..num_people)(x[i,j]);