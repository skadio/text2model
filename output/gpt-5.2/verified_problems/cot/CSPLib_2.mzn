% Parameters
int: S;                      % number of slots per template
int: t;                      % number of templates
int: n;                      % number of design variations
array[1..n] of int: d;       % demand for each variation

% Variables
array[1..t, 1..S] of var 1..n: slot;     % design assigned to each slot of each template

array[1..t, 1..n] of var 0..S: cnt;       % count of slots of each variation in each template
array[1..n] of var 0..max(d): prod;       % total production per variation
array[1..n] of var 0..max(d): surplus;    % surplus per variation
var 0..sum(d): total_surplus;

% Constraints
constraint
  forall(i in 1..t, v in 1..n) (
    cnt[i,v] = sum(j in 1..S) (bool2int(slot[i,j] == v))
  );

constraint
  forall(i in 1..t) (
    sum(v in 1..n)(cnt[i,v]) = S
  );

constraint
  forall(v in 1..n) (
    prod[v] = sum(i in 1..t)(cnt[i,v])
  );

constraint
  forall(v in 1..n) (
    prod[v] >= d[v]
  );

constraint
  forall(v in 1..n) (
    surplus[v] = prod[v] - d[v]
  );

constraint
  total_surplus = sum(v in 1..n)(surplus[v]);

% Lexicographic ordering of templates (compare slot sequences)
include "globals.mzn";
constraint
  forall(i in 1..t-1) (
    lex_lesseq([slot[i,j] | j in 1..S], [slot[i+1,j] | j in 1..S])
  );

% Objective
solve minimize total_surplus;