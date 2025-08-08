include "globals.mzn";

/* ---------- Data ---------- */
int: num_work;
int: num_shifts;
int: min_num_shifts;

/* each shift is represented by the set of works it covers */
array[1..num_shifts] of set of 1..num_work: shift_works;

/* ---------- Variables ---------- */
array[1..num_shifts] of var 0..1: x;   % 1 = shift is selected

/* ---------- Constraints ---------- */

/* Every work must be covered by exactly one selected shift */
constraint
  forall(w in 1..num_work)(
    sum( [ x[s] | s in 1..num_shifts where w in shift_works[s] ] ) == 1
  );

/* At least the required minimum number of shifts must be used */
constraint sum(x) >= min_num_shifts;

/* ---------- Objective ---------- */
solve minimize sum(x);

/* ---------- Output ---------- */
output [
  "Number of shifts used: ", show(sum(x)), "\n",
  "Selected shifts: ", show([ s | s in 1..num_shifts where x[s] == 1]), "\n"
];