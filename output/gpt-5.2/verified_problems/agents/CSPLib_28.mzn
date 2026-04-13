% Parameters
int: v;          % Number of distinct objects (points)
int: k;          % Number of distinct objects in each block
int: lambda;     % Number of blocks in which any pair of distinct objects co-occurs

% Derived parameters / index sets
set of int: OBJECTS = 1..v;  % Index set of objects/points


% Variables
% We do not take the number of blocks b or the replication number r as inputs,
% so we model them as decision variables.
int: b_ub = v * v;                 % Safe upper bound on number of blocks
var 1..b_ub: b;                    % Number of (active) blocks

int: r_ub = b_ub;                  % Safe upper bound on replication number
var 0..r_ub: r;                    % Replication: occurrences of each object across all blocks

array[1..b_ub, OBJECTS] of var 0..1: in_block;
% in_block[blk,obj] = 1 if object obj is in block blk, else 0.
% Only the first b blocks are considered active; remaining rows are forced to 0.


% Constraints

% --- Activate exactly b blocks and deactivate remaining blocks ---
% For inactive blocks (blk > b), force the entire row to be 0.
constraint
  forall(blk in 1..b_ub) (
    (blk > b) -> forall(obj in OBJECTS) (in_block[blk, obj] = 0)
  );

% --- Block size: each active block contains exactly k objects ---
constraint
  forall(blk in 1..b_ub) (
    (blk <= b) -> (sum(obj in OBJECTS)(in_block[blk, obj]) = k)
  );

% --- Replication: each object occurs in exactly r active blocks ---
% (Inactive blocks are all-zero so they do not affect the count.)
constraint
  forall(obj in OBJECTS) (
    sum(blk in 1..b_ub)(in_block[blk, obj]) = r
  );

% --- Pairwise balance: every pair co-occurs in exactly lambda blocks ---
constraint
  forall(o1 in OBJECTS, o2 in OBJECTS where o1 < o2) (
    sum(blk in 1..b_ub)(in_block[blk, o1] * in_block[blk, o2]) = lambda
  );


% Objective
solve satisfy;