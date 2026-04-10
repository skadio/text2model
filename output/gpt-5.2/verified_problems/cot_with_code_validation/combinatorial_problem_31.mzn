% Parameters
int: num_people;
array[1..num_people, 1..num_people] of bool: compatible;

% Decision variables: x[i,j] = 1 if i donates to j
array[1..num_people, 1..num_people] of var 0..1: x;

% No self-donation
constraint forall(i in 1..num_people) (x[i,i] = 0);

% Respect compatibility
constraint forall(i in 1..num_people, j in 1..num_people) (
  x[i,j] <= bool2int(compatible[i,j])
);

% Flow conservation: a person donates iff they receive
constraint forall(i in 1..num_people) (
  sum(j in 1..num_people)(x[i,j]) = sum(j in 1..num_people)(x[j,i])
);

% At most one outgoing and at most one incoming
constraint forall(i in 1..num_people) (sum(j in 1..num_people)(x[i,j]) <= 1);
constraint forall(i in 1..num_people) (sum(j in 1..num_people)(x[j,i]) <= 1);

% Objective: maximize number of exchanges
solve maximize sum(i in 1..num_people, j in 1..num_people)(x[i,j]);