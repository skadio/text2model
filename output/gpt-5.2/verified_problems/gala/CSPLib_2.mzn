include "globals.mzn";

%-------------------------
% Input data (from .dzn)
%-------------------------
int: S;                     % slots per template
int: t;                     % number of templates
int: n;                     % number of design variations
array[1..n] of int: d;      % minimum demand for each variation

%-------------------------
% Decision variables
%-------------------------
% slot[k,s] = variation printed in slot s of template k
array[1..t, 1..S] of var 1..n: slot;

% slots_of_var[k,v] = how many slots on template k are assigned to variation v
array[1..t, 1..n] of var 0..S: slots_of_var;

% total_slots[v] = total number of slots (across all templates) assigned to variation v
array[1..n] of var 0..(t*S): total_slots;

% runlen = number of times each template is used (each use produces one mother sheet run)
var 0..max(d): runlen;

% produced_units[v] = total units of variation v manufactured
array[1..n] of var 0..(t*S*max(d)): produced_units;

% surplus per variation and total surplus
array[1..n] of var 0..(t*S*max(d)): surplus_v;
var 0..(t*S*max(d)): surplus;

%-------------------------
% Constraints
%-------------------------

% Count how many slots of each variation appear on each template
constraint
  forall(k in 1..t, v in 1..n)(
    count([slot[k,s] | s in 1..S], v, slots_of_var[k,v])
  );

% Total slots per variation across all templates (GCC over all slots)
constraint global_cardinality([slot[k,s] | k in 1..t, s in 1..S], 1..n, total_slots);

% Link produced units to run length
constraint forall(v in 1..n)(
  produced_units[v] = runlen * total_slots[v]
);

% Meet demands
constraint forall(v in 1..n)(
  produced_units[v] >= d[v]
);

% Surplus definition
constraint forall(v in 1..n)(
  surplus_v[v] = produced_units[v] - d[v]
);
constraint surplus = sum(v in 1..n)(surplus_v[v]);

% Templates organized in lexicographic order
constraint forall(k in 1..t-1)(
  lex_lesseq([slot[k,j] | j in 1..S], [slot[k+1,j] | j in 1..S])
);

%-------------------------
% Objective
%-------------------------
solve minimize surplus;

%-------------------------
% Output
%-------------------------
output [
  "runlen = ", show(runlen), "\n",
  "total_slots = ", show(total_slots), "\n",
  "produced_units = ", show(produced_units), "\n",
  "surplus_v = ", show(surplus_v), "\n",
  "surplus = ", show(surplus), "\n",
  "slot =\n",
  concat([ concat([ show(slot[k,s]) ++ if s==S then "\n" else " " endif
                  | s in 1..S ])
          | k in 1..t ])
];