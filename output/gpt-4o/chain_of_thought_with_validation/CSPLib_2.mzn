include "globals.mzn";

% Parameters
int: S;                                   % Number of slots on every template
int: t;                                   % Number of templates
int: n;                                   % Number of design variations
array[1..n] of int: d;                    % Minimum demand for every design
int: total_demand = sum(j in 1..n)(d[j]); % Useful upper-bound

% Variables
array[1..t,1..n] of var 0..S: a;                    % a[i,j] = slots of design j on template i
array[1..t]       of var 0..total_demand: x;        % Sheets printed of template i
array[1..n]       of var 0..total_demand: surplus;  % Surplus produced for every design

% Constraints
constraint
    forall(i in 1..t) (               % Every template has exactly S slots
        sum(j in 1..n)(a[i,j]) = S
    );

constraint
    forall(j in 1..n) (               % Production covers demand plus surplus
        sum(i in 1..t)(a[i,j] * x[i]) = d[j] + surplus[j]
    );

constraint
    forall(i in 1..t-1) (             % Templates ordered lexicographically
        lex_lesseq([a[i,j] | j in 1..n],
                   [a[i+1,j] | j in 1..n])
    );

% Objective
solve minimize sum(j in 1..n)(surplus[j]);