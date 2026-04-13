% Parameters
int: m;

% Variables
array[1..m] of var int: a;
var int: L;

% Constraints
constraint a[1] = 0;
constraint a[m] = L;

constraint forall(i in 1..m-1) (a[i] < a[i+1]);
constraint forall(i in 1..m) (a[i] >= 0);

% Simple upper bound to keep domains finite
constraint L >= 0;
constraint L <= (m - 1) * (m - 1);

% Place marks within the ruler length
constraint forall(i in 1..m) (a[i] <= L);

% Symmetry breaking: first difference less than last difference
constraint a[2] - a[1] < a[m] - a[m-1];

% All pairwise differences are distinct
array[1..(m*(m-1)) div 2] of var int: d;
constraint forall(k in 1..(m*(m-1)) div 2) (d[k] >= 1 /\ d[k] <= L);

constraint
  let {
    array[1..(m*(m-1)) div 2] of int: I = [i | i in 1..m-1, j in i+1..m],
    array[1..(m*(m-1)) div 2] of int: J = [j | i in 1..m-1, j in i+1..m]
  } in
    forall(k in 1..(m*(m-1)) div 2) (
      d[k] = a[J[k]] - a[I[k]]
    );

constraint all_different(d);

% Objective
solve minimize L;