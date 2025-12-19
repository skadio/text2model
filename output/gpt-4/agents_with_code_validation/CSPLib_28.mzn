% Parameters
int: v; % Number of distinct objects
int: k; % Number of distinct objects in each block
int: lambda; % Scalar product between any pair of distinct rows

% Variables
array[1..v, 1..v] of var 0..1: blocks; % Matrix representing the blocks. If blocks[i,j] = 1, then object i is in block j
array[1..v] of var 0..v: object_occurrences; % Number of occurrences of each object in blocks
array[1..v, 1..v] of var 0..1: pair_occurrences; % Matrix representing the pairs which appear together. If pair_occurrences[i,j] = 1, then object i and j appear together in a block

% Constraints

% Each block should contain exactly k distinct objects
constraint forall(i in 1..v) (
  sum(j in 1..v) (blocks[i,j]) = k
);

% Each object should appear in exactly object_occurrences[i] blocks
constraint forall(i in 1..v) (
  sum(j in 1..v) (blocks[j,i]) = object_occurrences[i]
);

% Each pair of distinct objects should appear together in exactly lambda blocks
constraint forall(i in 1..v, j in i+1..v) (
  sum(k in 1..v) (blocks[i,k] * blocks[j,k]) = lambda
);

% pair_occurrences[i,j] should be 1 if and only if objects i and j appear together in a block
constraint forall(i in 1..v, j in i+1..v) (
  pair_occurrences[i,j] = if sum(k in 1..v) (blocks[i,k] * blocks[j,k]) > 0 then 1 else 0 endif
);

% Objective
solve satisfy;