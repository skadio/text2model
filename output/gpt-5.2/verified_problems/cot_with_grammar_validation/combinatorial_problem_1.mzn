% Parameters
int: n;
array[1..n] of int: a;
int: k;

% Variables
array[1..n] of var 1..k: g;                 % group assignment for each item
array[1..k] of var 0..sum(a): s;            % sum in each group
var 0..sum(a): m;                           % maximum group sum

% Constraints
constraint
  forall(j in 1..k)(
    s[j] = sum(i in 1..n)( a[i] * bool2int(g[i] = j) )
  );

constraint
  forall(j in 1..k)(
    s[j] <= m
  );

% Objective
solve minimize m;