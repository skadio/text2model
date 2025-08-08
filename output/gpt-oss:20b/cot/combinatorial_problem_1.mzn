% Parameters
int: n;
array[1..n] of int: a;
int: k;
int: totalSum = sum(a);

% Variables
array[1..n] of var 1..k: group;
array[1..k] of var 0..totalSum: sum_g;

% Constraints
constraint forall(g in 1..k) (
    sum_g[g] = sum([a[i] * bool2int(group[i] == g) | i in 1..n])
);

% Objective
solve minimize max(sum_g);