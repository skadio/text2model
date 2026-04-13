int: num_work;
int: num_shifts;
int: min_num_shifts;

% shifts[s,w] = true if shift s covers work w
array[1..num_shifts, 1..num_work] of bool: shifts;

array[1..num_shifts] of var 0..1: use_shift;

constraint
  forall(w in 1..num_work) (
    sum(s in 1..num_shifts) (bool2int(shifts[s,w]) * use_shift[s]) = 1
  );

constraint sum(s in 1..num_shifts)(use_shift[s]) >= min_num_shifts;

solve minimize sum(s in 1..num_shifts)(use_shift[s]);

output [
  "num_used_shifts=", show(sum(s in 1..num_shifts)(use_shift[s])), "\n",
  "used_shifts=", show([s | s in 1..num_shifts where fix(use_shift[s]) = 1]), "\n"
];