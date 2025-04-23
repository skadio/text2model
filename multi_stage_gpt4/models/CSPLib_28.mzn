% Parameters
int: v; % Number of distinct objects
int: k; % Number of distinct objects in each block
int: lambda; % Scalar product between any pair of distinct rows

% Variables
% The variable 'blocks' represents the arrangement of objects into blocks. 
% It is a 2D array where each row represents a block and each column represents an object. 
% The value at a specific position (i, j) is 1 if the object j is in the block i, and 0 otherwise.
array[1..v, 1..v] of var 0..1: blocks;

% Constraints

% Each object appears in a fixed number of blocks
constraint forall(i in 1..v)(
  sum(j in 1..v)(blocks[j, i]) = k
);

% Each block contains a fixed number of objects
constraint forall(i in 1..v)(
  sum(j in 1..v)(blocks[i, j]) = k
);

% Every pair of objects appears together in a fixed number of blocks
constraint forall(i in 1..v, j in i+1..v)(
  sum(k in 1..v)(blocks[k, i] * blocks[k, j]) = lambda
);

% Objective
solve satisfy;