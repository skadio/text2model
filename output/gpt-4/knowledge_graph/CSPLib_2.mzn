include "globals.mzn";

% Parameters
int: S; % Number of slots per template
int: t; % Number of templates to produce
int: n; % Number of variations of carton designs
array[1..n] of int: d; % Array indicating how many of each variation must be printed

% Variables
array[1..t, 1..S] of var 1..n: template; % The design variation assigned to each slot of each template
array[1..n] of var 0..S*t: production; % The total production of each design variation

% Constraints
constraint forall(i in 1..n) (
    production[i] = sum(j in 1..t, k in 1..S) (template[j, k] = i)
);

constraint forall(i in 1..n) (
    production[i] >= d[i]
);

% Objective
var int: surplus = sum(i in 1..n) (production[i] - d[i]);
minimize surplus;

% Lexicographic order
constraint forall(i in 1..t-1) (
    lex_lesseq([template[i, j] | j in 1..S], [template[i+1, j] | j in 1..S])
);

% Solve and output
solve :: int_search([template[i, j] | i in 1..t, j in 1..S], first_fail, indomain_min, complete) minimize surplus;

output [ "Template " ++ show(i) ++ ": " ++ show([template[i, j] | j in 1..S]) ++ "\n" | i in 1..t ] ++
       [ "Production: " ++ show([production[i] | i in 1..n]) ++ "\n" ] ++
       [ "Surplus: " ++ show(surplus) ++ "\n" ];