% Parameters
int: S; % Number of slots per template
int: t; % Number of templates to produce
int: n; % Number of variations of carton designs
array[1..n] of int: d; % Array indicating how many of each variation must be printed

% Variables
array[1..t, 1..S] of var 1..n: templates; % Configuration of the slots for the templates
array[1..n] of var 0..S*t: production; % Number of each variation produced

% Constraints
% Each slot in each template must be assigned to exactly one design variation
constraint forall(i in 1..t, j in 1..S) (
  templates[i,j] in 1..n
);

% The number of each variation produced must be at least the demand
constraint forall(i in 1..n) (
  production[i] = sum(j in 1..t, k in 1..S) (if templates[j,k] = i then 1 else 0 endif)
);

% The number of each variation produced must be at least the demand
constraint forall(i in 1..n) (
  production[i] >= d[i]
);

% The templates are organized in lexicographic order
constraint forall(i in 1..t-1) (
  lex_lesseq(templates[i,1..S], templates[i+1,1..S])
);

% Objective
% Minimize the total amount of surplus
var int: surplus = sum(i in 1..n) (production[i] - d[i]);
solve minimize surplus;