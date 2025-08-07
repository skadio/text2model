include "globals.mzn";

int: n;
array[1..n] of int: b;
array[1..n] of int: t;
int: num_people;

int: total_bottles = sum(b);
int: total_liquid = sum([b[i] * t[i] | i in 1..n]);

int: B = total_bottles div num_people;
int: L = total_liquid div num_people;

constraint total_bottles mod num_people = 0;
constraint total_liquid mod num_people = 0;

int: max_b = max(b);
array[1..num_people, 1..n] of var 0..max_b: x;

constraint forall(i in 1..n) (
    sum(p in 1..num_people) x[p][i] = b[i]
);

constraint forall(p in 1..num_people) (
    sum(i in 1..n) x[p][i] = B
);

constraint forall(p in 1..num_people) (
    sum(i in 1..n) x[p][i] * t[i] = L
);

constraint forall(p in 1..num_people-1) (
    lex_leq([x[p][i] | i in 1..n], [x[p+1][i] | i in 1..n])
);

solve satisfy;

output [
    "Solution:\n",
    concat([ "Person " ++ show(p) ++ ": " ++ show([x[p][i] | i in 1..n]) ++ "\n" | p in 1..num_people ])
];