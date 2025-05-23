% Parameters
int: S; % Number of slots per template
int: t; % Number of templates to produce
int: n; % Number of variations of carton designs
array[1..n] of int: d; % Array indicating how many of each variation must be printed

% Variables
array[1..t, 1..S] of var 1..n: templates; % Configuration of the slots for the templates
array[1..n] of var 0..(S*t): production; % Number of each variation produced

% Constraints
constraint forall(i in 1..n) (
  production[i] = sum(j in 1..t, k in 1..S) (templates[j, k] = i)
);
constraint forall(i in 1..n) (
  production[i] >= d[i]
);
constraint forall(i in 1..t) (
  increasing([templates[i, j] | j in 1..S])
);

% Objective
var int: surplus = sum(i in 1..n) (production[i] - d[i]);
solve minimize surplus;