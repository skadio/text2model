int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

array[1..num_shifts] of var bool: x;

constraint
  forall(j in 1..num_work) (
    sum([x[i] | i in 1..num_shifts where j in shifts[i]]) == 1
  );

constraint
  sum(x) >= min_num_shifts;

solve minimize sum(x);

output [
  "Number of shifts used: ", show(sum(x)), "\n",
  "Selected shifts: ", show([i | i in 1..num_shifts where x[i] = true]), "\n"
];