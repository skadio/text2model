include "globals.mzn";

/* Parameters (provided via the .dzn file) */
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

/* Decision Variables:
   For each possible shift, decide whether to select (1) or not (0)
*/
array[1..num_shifts] of var 0..1: selected;

/* Constraint 1: Every piece of work must be covered exactly once.
   For each work w, the sum over all shifts that cover w must equal 1.
*/
constraint
  forall(w in 1..num_work) (
    sum(i in 1..num_shifts)( if w in shifts[i] then selected[i] else 0 ) = 1
  );

/* Constraint 2: At least min_num_shifts shifts must be selected */
constraint
  sum(i in 1..num_shifts)(selected[i]) >= min_num_shifts;

/* Objective: Minimize the total number of selected shifts */
var int: total_shifts = sum(i in 1..num_shifts)(selected[i]);
solve minimize total_shifts;

/* Output block */
output [
  "Total shifts used = ", show(total_shifts), "\nSelected shifts indices: ",
  show([i | i in 1..num_shifts where selected[i] = 1]), "\n"
];