int: num_work;
int: num_shifts;
int: min_num_shifts;

array[1..num_shifts, 1..num_work] of bool: shifts;

array[1..num_shifts] of var bool: use_shift;

constraint forall(w in 1..num_work) (
  sum(s in 1..num_shifts) (bool2int(shifts[s,w]) * bool2int(use_shift[s])) = 1
);

constraint sum(s in 1..num_shifts) (bool2int(use_shift[s])) >= min_num_shifts;

solve minimize sum(s in 1..num_shifts) (bool2int(use_shift[s]));