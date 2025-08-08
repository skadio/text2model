include "globals.mzn";

int: S;  % Number of slots per template
int: t;  % Number of templates to produce
int: n;  % Number of variations of carton designs
array[1..n] of int: d;  % Minimum demand for each variation

/* Variables */
array[1..t, 1..S] of var 1..n: slots;  % Assignments of slots to design variations
array[1..n] of var 0..S*t: counts;  % Counts of each design variation in the slots

/* Constraints */
constraint global_cardinality(flatten(slots), 1..n, counts);
constraint forall(i in 1..n)(counts[i] >= d[i]);  % Ensure minimum demand is met

/* Ensure templates are in lexicographic order */
constraint forall(i in 1..t-1)(
  lex_less([slots[i,j] | j in 1..S], [slots[i+1,j] | j in 1..S])
);

/* Ensure the configurations of slots are increasing */
constraint increasing(flatten(slots));

/* Solve & output */
solve minimize sum(counts) - sum(d);  % Minimize surplus
output [ "Slots = ", show(slots), "\nCounts = ", show(counts), "\n" ];