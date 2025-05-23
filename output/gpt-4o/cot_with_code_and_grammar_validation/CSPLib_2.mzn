% Parameters
include "globals.mzn";

int: S;                                     % Number of slots per template
int: t;                                     % Number of templates
int: n;                                     % Number of design variations
array[1..n] of int: d;                      % Minimum demand for each variation

int: totalDemand = sum(i in 1..n)(d[i]);    % Helper constant
int: UY = totalDemand;                      % Safe upper bound on prints per template

% Variables
array[1..t, 1..n] of var 0..S: x;           % Slots of variation v on template k
array[1..t]            of var 0..UY: y;     % Number of sheets printed with template k
array[1..t, 1..n] of var 0..UY*S: prod;     % Production of variation v from template k
var 0..UY*S*n: surplus;                     % Total surplus to minimise

% Constraints
constraint
    forall(k in 1..t)(
        sum(v in 1..n)(x[k,v]) = S          % Each template uses exactly S slots
    );

constraint
    forall(k in 1..t, v in 1..n)(
        prod[k,v] = x[k,v] * y[k]           % Link production, slots and prints
    );

constraint
    forall(v in 1..n)(
        sum(k in 1..t)(prod[k,v]) >= d[v]   % Meet every demand
    );

constraint
    surplus = sum(v in 1..n)(sum(k in 1..t)(prod[k,v])) - totalDemand;

constraint
    forall(k in 1..t-1)(
        lex_lesseq([x[k,v] | v in 1..n],    % Lexicographic ordering of templates
                   [x[k+1,v] | v in 1..n])
    );

% Objective
solve minimize surplus;