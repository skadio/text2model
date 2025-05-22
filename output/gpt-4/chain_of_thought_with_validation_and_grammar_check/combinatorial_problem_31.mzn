% Parameters
int: num_people;
array[1..num_people, 1..num_people] of int: compatible;

% Variables
array[1..num_people] of var 1..num_people: donor_to;

% Constraints
constraint forall(i in 1..num_people) (
  donor_to[donor_to[i]] = i % Each person who donates a kidney also receives one
);

constraint forall(i in 1..num_people) (
  compatible[i, donor_to[i]] = 1 % Each person can only receive a kidney from a compatible donor
);

% Objective
var int: num_exchanges = sum(i in 1..num_people) (if donor_to[i] != i then 1 else 0 endif);
solve maximize num_exchanges;