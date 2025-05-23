% Parameters
int: num_people;
array[1..num_people, 1..num_people] of int: compatible;

% Variables
array[1..num_people] of var 1..num_people: donor_to;

% Constraints
constraint forall(i in 1..num_people) (
  compatible[i, donor_to[i]] = 1
);
constraint forall(i in 1..num_people) (
  exists(j in 1..num_people) (donor_to[j] = i)
);

% Objective
solve maximize sum(i in 1..num_people) (compatible[i, donor_to[i]]);