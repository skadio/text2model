include "globals.mzn";

% Number of slots per template
int: S;
% Number of templates to produce
int: t;
% Number of variations of carton designs
int: n;
% Array indicating how many of each variation must be printed
array[1..n] of int: d;

% Decision variable: the configuration of the slots for the templates
array[1..t, 1..S] of var 1..n: templates;

% Constraint: each design variation must be printed at least as many times as demanded
constraint forall(i in 1..n) (
    sum(j in 1..t, k in 1..S) (templates[j, k] = i) >= d[i]
);

% Objective: minimize the total amount of product manufactured that exceeds the demands
var int: surplus = sum(i in 1..n) (
    max(0, sum(j in 1..t, k in 1..S) (templates[j, k] = i) - d[i])
);
minimize surplus;

% Ensure that the templates are organized in lexicographic order
constraint forall(i in 1..t-1) (
    lex_lesseq(templates[i, 1..S], templates[i+1, 1..S])
);

solve satisfy;

output [ "Template " ++ show(i) ++ ": " ++ show(templates[i, 1..S]) ++ "\n" | i in 1..t ];