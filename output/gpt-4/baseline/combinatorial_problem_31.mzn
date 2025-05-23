include "globals.mzn";

% Number of people in the kidney exchange program
int: num_people;

% Compatibility matrix where each person has a set of compatible donors
array[1..num_people, 1..num_people] of bool: compatible;

% Decision variable: kidney exchange matrix
array[1..num_people, 1..num_people] of var 0..1: exchange;

% Each person can only donate one kidney
constraint forall(i in 1..num_people) (
  sum(j in 1..num_people) (exchange[i,j]) = 1
);

% Each person can only receive one kidney
constraint forall(j in 1..num_people) (
  sum(i in 1..num_people) (exchange[i,j]) = 1
);

% A person can only donate a kidney to a compatible person
constraint forall(i in 1..num_people, j in 1..num_people) (
  exchange[i,j] <= compatible[i,j]
);

% Objective: maximize the number of exchanges
solve maximize sum(i in 1..num_people, j in 1..num_people) (exchange[i,j]);

% Output the exchange matrix
output [ if fix(exchange[i,j]) = 1 then "Person " ++ show(i) ++ " donates to Person " ++ show(j) ++ "\n" else "" endif | i in 1..num_people, j in 1..num_people ];