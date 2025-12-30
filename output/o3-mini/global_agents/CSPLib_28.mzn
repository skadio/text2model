include "globals.mzn";

/* Input parameters provided via .dzn file */
int: v;       % Number of distinct objects
int: k;       % Number of objects per block
int: lambda;  % Each pair of distinct objects appears together in exactly lambda blocks

/* Derived parameters for a BIBD:
   r: number of blocks in which each object appears,
   b: total number of blocks.
   BIBD relations: r = lambda*(v-1)/(k-1) and b = v*r/k.
   These must be integers for a valid design.
*/
int: r = (lambda * (v - 1)) div (k - 1);
int: b = (v * r) div k;

/* Decision variable:
   blocks[i,j]: object in block i at position j.
   Each block is a k-tuple of objects chosen from 1..v.
*/
array[1..b, 1..k] of var 1..v: blocks;

/* Constraint 1: Within each block, all objects must be distinct */
constraint
    forall(i in 1..b) (
        all_different([ blocks[i, j] | j in 1..k ])
    );

/* Constraint 2: Each object appears exactly r times in the design */
constraint
    forall(o in 1..v) (
        count(flatten(blocks), o, r)
    );

/* Constraint 3: Each pair of distinct objects appears together exactly lambda times.
   For every pair (o1, o2) with o1 < o2, count the blocks where both occur.
*/
constraint
    forall(o1 in 1..v, o2 in o1+1..v) (
        sum(i in 1..b)(
            bool2int( exists(j in 1..k)( blocks[i,j] = o1 )
                      /\ exists(j in 1..k)( blocks[i,j] = o2 ) )
        ) = lambda
    );

/* Solve: We are simply generating a valid BIBD */
solve satisfy;

/* Output: Display the block design */
output [
    "BIBD with v = ", show(v), ", k = ", show(k), ", lambda = ", show(lambda), "\n",
    "Computed parameters: r = ", show(r), ", b = ", show(b), "\n",
    "Blocks:\n",
    concat([ "Block " ++ show(i) ++ ": " ++ show([ blocks[i,j] | j in 1..k ]) ++ "\n" | i in 1..b ])
];