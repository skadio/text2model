include "globals.mzn";

int: n;
array[1..n] of int: b;
array[1..n] of int: t;
int: num_people;

int: max_b = max(b);

array[1..num_people, 1..n] of var 0..max_b: x;
var 0..sum(b): B;
var 0..sum(i in 1..n)(t[i] * b[i]): L;

constraint
  forall(i in 1..n)(
    sum(p in 1..num_people)(x[p,i]) = b[i]
  );

constraint
  forall(p in 1..num_people)(
    sum(i in 1..n)(x[p,i]) = B
  );

constraint
  forall(p in 1..num_people)(
    sum(i in 1..n)(t[i] * x[p,i]) = L
  );

constraint sum(b) = num_people * B;
constraint sum(i in 1..n)(t[i] * b[i]) = num_people * L;

constraint
  forall(p in 1..num_people-1)(
    lex_lesseq([x[p,i] | i in 1..n], [x[p+1,i] | i in 1..n])
  );

solve satisfy;