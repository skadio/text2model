include "globals.mzn";

int: v;
int: k;
int: lambda;

set of int: OBJ = 1..v;

array[OBJ, OBJ] of var 0..1: x;

constraint
  forall(i in OBJ)(x[i,i] = 0);

constraint
  forall(i in OBJ)(
    sum(j in OBJ)(x[i,j]) = k
  );

constraint
  forall(j in OBJ)(
    sum(i in OBJ)(x[i,j]) = k
  );

constraint
  forall(i,j in OBJ where i < j)(
    sum(t in OBJ)(x[i,t] * x[j,t]) = lambda
  );

constraint
  lex_less([x[i,j] | j in OBJ], [x[i+1,j] | j in OBJ]) \/ i = v
  forall(i in 1..v-1);

constraint
  lex_less([x[i,j] | i in OBJ], [x[i,j+1] | i in OBJ]) \/ j = v
  forall(j in 1..v-1);

solve satisfy;

output [
  "x =\n",
  concat([ concat([ if fix(x[i,j]) = 1 then "1 " else "0 " endif | j in OBJ ]) ++ "\n"
         | i in OBJ ])
];