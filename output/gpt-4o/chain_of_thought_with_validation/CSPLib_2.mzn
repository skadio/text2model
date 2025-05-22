include "globals.mzn";

% Parameters
int: S;                                 % number of slots per template
int: t;                                 % number of templates
int: n;                                 % number of design variations
array[1..n] of int: d;                  % minimum demand for each variation

int: TOTDEM = sum(v in 1..n)(d[v]);     % total demand over all variations

% Variables
array[1..t, 1..n] of var 0..S: a;                   % slots of variation v on template k
array[1..t]          of var 0..TOTDEM: p;           % runs of template k
array[1..t, 1..n] of var 0..S*TOTDEM: prod;         % output of variation v from template k
array[1..n]       of var 0..S*TOTDEM: production;   % total output of variation v
var 0..S*TOTDEM: surplus;                           % total surplus over all variations

% Constraints
% 1. Every template must allocate exactly S slots
constraint
  forall(k in 1..t) (
    sum(v in 1..n)(a[k,v]) = S
  );

% 2. Compute produced quantity of each variation on each template
constraint
  forall(k in 1..t, v in 1..n) (
    prod[k,v] = a[k,v] * p[k]
  );

% 3. Aggregate production over templates
constraint
  forall(v in 1..n) (
    production[v] = sum(k in 1..t)(prod[k,v])
  );

% 4. Meet or exceed demand for every variation
constraint
  forall(v in 1..n) (
    production[v] >= d[v]
  );

% 5. Define total surplus
constraint
  surplus = sum(v in 1..n)(production[v]) - TOTDEM;

% 6. Lexicographic ordering of templates
constraint
  forall(k in 1..t-1) (
    lex_lesseq([a[k,v] | v in 1..n],
               [a[k+1,v] | v in 1..n])
  );

% Objective
solve minimize surplus;