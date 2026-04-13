include "globals.mzn";

% Data from the .dzn file
int: S;                       % Number of slots per template
int: t;                       % Number of templates available
int: n;                       % Number of design variations
array[1..n] of int: d;        % Minimum demand for each design variation (v=1..n)

% An upper bound for the number of copies to print for any template.
% Since in the worst case a template might contribute only 1 copy of some design variation,
% we set the upper bound to max(d).
int: maxCopies = max(d);

% Decision variables
% template[i,j] is the design variation (between 1 and n) assigned to slot j of template i.
array[1..t, 1..S] of var 1..n: template;

% x[i] is the number of times template i is printed.
array[1..t] of var 0..maxCopies: x;

% Auxiliary: count[i,v] is the number of slots in template i assigned to variation v.
% We compute it using a summation over the S slots.
array[1..t, 1..n] of var 0..S: count;
constraint
  forall(i in 1..t, v in 1..n) (
    count[i, v] = sum(j in 1..S)( if template[i,j] == v then 1 else 0 endif )
  );

% Production constraints:
% For each design variation v, the total production (over all templates) must meet the demand.
% The production for variation v is: sum_{i=1}^{t} ( x[i] * count[i,v] ).
constraint
  forall(v in 1..n) (
    sum(i in 1..t)( x[i] * count[i, v] ) >= d[v]
  );

% Templates should be arranged in lexicographic (non-decreasing) order:
constraint lex_chain([ [ template[i, j] | j in 1..S ] | i in 1..t ]);

% Objective: Minimize the total surplus.
% Total production = sum(i in 1..t) x[i] * S  (each printed template yields S items)
% Surplus = total production - total demand.
var int: total_printings = sum(i in 1..t)( x[i] );
var int: surplus = total_printings * S - sum(v in 1..n)( d[v] );
solve minimize surplus;

% Output: display the chosen template configurations, the number of prints for each, and surplus.
output [
  "Templates:\n",
  concat([ "Template " ++ show(i) ++ ": " ++ show([ template[i,j] | j in 1..S ]) ++ "\n" 
           | i in 1..t ]),
  "\nNumber of prints for each template: ", show([ x[i] | i in 1..t ]), "\n",
  "Total surplus: ", show(surplus), "\n"
];