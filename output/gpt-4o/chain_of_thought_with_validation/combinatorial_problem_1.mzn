% Parameters
int: n;
set of int: Items = 1..n;

array[Items] of int: a;

int: k;
set of int: Groups = 1..k;

% Variables
array[Items] of var Groups: grp;               % group assignment for each item
array[Groups] of var 0..sum(a): load;          % total value in each group
var 0..sum(a): max_load;                       % maximum load among all groups

% Constraints
constraint
  forall(g in Groups) (
    load[g] = sum(i in Items)( a[i] * bool2int(grp[i] == g) )
);

constraint
  sum(g in Groups)( load[g] ) = sum(a);

constraint
  max_load = max(load);

% Objective
solve minimize max_load;