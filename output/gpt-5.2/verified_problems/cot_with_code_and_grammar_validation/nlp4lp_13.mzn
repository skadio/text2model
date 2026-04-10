int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

array[C, C] of var float: x;
array[C] of var float: end_amt;

constraint forall(i in C, j in C) (x[i, j] >= 0.0);
constraint forall(i in C) (x[i, i] = 0.0);

constraint forall(i in C) (
  sum(j in C)(x[i, j]) <= Limit[i]
);

constraint forall(i in C) (
  sum(j in C)(x[j, i] * Rate[j, i]) <= Limit[i]
);

constraint forall(i in C) (
  end_amt[i] = Start[i]
               + sum(j in C)(x[j, i] * Rate[j, i])
               - sum(j in C)(x[i, j])
);

constraint forall(i in C) (end_amt[i] >= 0.0);

solve maximize sum(i in C)(end_amt[i]);