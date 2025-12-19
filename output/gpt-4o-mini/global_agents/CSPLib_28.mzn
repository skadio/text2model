include "globals.mzn";

int: v;  % Number of distinct objects
int: k;  % Number of distinct objects in each block
int: lambda;  % Scalar product between any pair of distinct rows

/* Variables */
array[1..v] of var 0..1: x;  % Variables representing the presence of each object in blocks
array[1..v, 1..v] of var 0..1: pair_count;  % Count of pairs appearing together

/* Constraints */
constraint count(x, 1, lambda);  % Each object appears in exactly lambda blocks

/* Each pair of distinct objects must appear together in exactly lambda blocks */
constraint forall(i in 1..v, j in i+1..v) (
    pair_count[i, j] = lambda
);

/* Linking: Ensure that the pair count is consistent with the presence of objects */
constraint forall(i in 1..v, j in 1..v) (
    pair_count[i, j] <= x[i] + x[j]  % A pair can only be counted if both objects are present
);

/* Solve & output */
solve satisfy;
output [ "Presence of objects = ", show(x), "\nPair counts = ", show(pair_count), "\n" ];