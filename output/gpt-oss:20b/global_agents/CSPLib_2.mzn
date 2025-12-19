include "globals.mzn";

int: S;                     % number of slots per template
int: t;                     % number of templates
int: n;                     % number of design variations
array[1..n] of int: d;     % minimum demand for each variation

/* ------------------------------------------------------------------
   Variables
   ------------------------------------------------------------------ */
array[1..t,1..S] of var 1..n: slots;          % assignment of a variation to each slot
array[1..n] of var 0..t*S: occ;              % actual count of each variation

/* ------------------------------------------------------------------
   Constraints
   ------------------------------------------------------------------ */
/* Each variation must meet its minimum demand */
constraint
  forall(v in 1..n) (
    occ[v] >= d[v]
  );

/* Count the occurrences of each variation in all slots */
constraint
  global_cardinality(
    [slots[i,j] | i in 1..t, j in 1..S],
    1..n,
    occ
  );

/* Lexicographic order of templates (non‑decreasing) */
constraint
  forall(i in 1..t-1)(
    lex_lesseq(
      [slots[i,j]   | j in 1..S],
      [slots[i+1,j] | j in 1..S]
    )
  );

/* ------------------------------------------------------------------
   Solve
   ------------------------------------------------------------------ */
solve satisfy;

/* ------------------------------------------------------------------
   Output
   ------------------------------------------------------------------ */
output [
  "Template " ++ show(i) ++ ": " ++ show([slots[i,j] | j in 1..S]) ++ "\n"
  | i in 1..t
] ++ [
  "\nCounts per variation: " ++ show(occ) ++ "\n"
];