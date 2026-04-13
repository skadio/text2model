include "alldifferent.mzn";

int: n;

array[1..n] of var 1..n: queens;

constraint alldifferent(queens);

constraint alldifferent([queens[i] + i | i in 1..n]);

constraint alldifferent([queens[i] - i | i in 1..n]);

solve satisfy;