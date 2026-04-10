int: num_work;
int: num_shifts;
int: min_num_shifts;

set of int: WORK = 1..num_work;
set of int: SHIFTS = 1..num_shifts;

/*
  shifts[s] is the set of works covered by shift s.
  Expected in .dzn, e.g.:
    shifts = [ {1,3,5}, {2,4}, ... ];
*/
array[SHIFTS] of set of WORK: shifts;

array[SHIFTS] of var 0..1: shift_selection;

constraint
  forall(w in WORK) (
    sum(s in SHIFTS)(bool2int(w in shifts[s]) * shift_selection[s]) = 1
  );

constraint
  sum(s in SHIFTS)(shift_selection[s]) >= min_num_shifts;

solve minimize sum(s in SHIFTS)(shift_selection[s]);

output [
  "num_selected_shifts=", show(sum(s in SHIFTS)(shift_selection[s])), "\n",
  "selected_shifts=", show([s | s in SHIFTS where fix(shift_selection[s]) = 1]), "\n"
];