% Parameters
int: num_people;
array[1..num_people, 1..num_people] of 0..1: compatible;

% Variables
array[1..num_people, 1..num_people] of var 0..1: exchange;

% Constraints
constraint forall(i in 1..num_people)(sum(j in 1..num_people)(exchange[i,j]) = 1);
constraint forall(i in 1..num_people)(sum(j in 1..num_people)(exchange[j,i]) = 1);
constraint forall(i in 1..num_people, j in 1..num_people)(exchange[i,j] <= compatible[i,j]);

% Objective
solve maximize sum(i in 1..num_people, j in 1..num_people)(exchange[i,j]);