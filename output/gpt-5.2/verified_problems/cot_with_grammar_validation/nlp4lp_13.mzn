int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

array[C, C] of var 0.0..1.0e9: x;
array[C] of var 0.0..1.0e9: end_amt;

var 0.0..1.0e12: objective_value;

constraint forall(i in C, j in C) (x[i,j] >= 0.0);

constraint forall(i in C) (
  sum(j in C)(x[i,j]) <= Limit[i] /\
  sum(j in C)(x[j,i]) <= Limit[i]
);

constraint forall(i in C) (
  end_amt[i] = Start[i]
               - sum(j in C)(x[i,j])
               + sum(j in C)(Rate[j,i] * x[j,i])
);

constraint forall(i in C) (end_amt[i] >= 0.0);

constraint objective_value = sum(i in C)(end_amt[i]);

solve maximize objective_value;