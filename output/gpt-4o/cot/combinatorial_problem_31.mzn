% Parameters
int: num_people;
array[1..num_people, 1..num_people] of bool: compatible;

% Variables
array[1..num_people, 1..num_people] of var 0..1: x;

% Constraints
% 1. Donations only along compatible pairs
constraint
  forall(i in 1..num_people, j in 1..num_people) (
    x[i,j] <= bool2int(compatible[i,j])
  );

% 2. No self-donations
constraint
  forall(p in 1..num_people) (
    x[p,p] = 0
  );

% 3. Each participant donates at most once
constraint
  forall(p in 1..num_people) (
    sum(j in 1..num_people)(x[p,j]) <= 1
  );

% 4. Each participant receives at most once
constraint
  forall(p in 1..num_people) (
    sum(i in 1..num_people)(x[i,p]) <= 1
  );

% 5. Receive–donate balance (participation only in closed cycles)
constraint
  forall(p in 1..num_people) (
    sum(j in 1..num_people)(x[p,j]) = sum(i in 1..num_people)(x[i,p])
  );

% Objective
solve maximize
  sum(i in 1..num_people, j in 1..num_people)(x[i,j]);