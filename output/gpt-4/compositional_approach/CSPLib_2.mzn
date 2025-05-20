% Parameters
int: S; % Number of slots per template
int: t; % Number of templates to produce
int: n; % Number of variations of carton designs
array[1..n] of int: d; % Array indicating how many of each variation must be printed

% Variables
array[1..t, 1..S] of var 1..n: templates; % Configuration of the slots for the templates
array[1..n] of var 0..S*t: production; % Total production of each design variation

% Constraints

% Each slot in a template must be assigned to exactly one design variation
constraint forall(i in 1..t, j in 1..S) (
  templates[i, j] in 1..n
);

% The total production of each design variation must be equal to the sum of the slots assigned to it in all templates
constraint forall(i in 1..n) (
  production[i] = sum(j in 1..t, k in 1..S) (if templates[j, k] = i then 1 else 0 endif)
);

% The total production of each design variation must be greater than or equal to its demand
constraint forall(i in 1..n) (
  production[i] >= d[i]
);

% The templates must be organized in lexicographic order
constraint forall(i in 1..t-1) (
  templates[i, 1..S] <lex= templates[i+1, 1..S]
);

% Objective
solve minimize sum(i in 1..n) (production[i] - d[i]);