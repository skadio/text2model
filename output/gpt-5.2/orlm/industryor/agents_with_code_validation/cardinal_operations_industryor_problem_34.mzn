include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: nBatches = 5;
int: nVats = 3;

set of int: BATCH = 1..nBatches;
set of int: VAT   = 1..nVats;

% Scale times by 10 to avoid floats (MiniZinc search is much faster on ints)
% Original matrix (hours):
% [ [3, 1, 1],
%   [2, 1.5, 1],
%   [3, 1.2, 1.3],
%   [2, 2, 2],
%   [2.1, 2, 3] ]
array[BATCH, VAT] of int: p =
  [| 30, 10, 10
   | 20, 15, 10
   | 30, 12, 13
   | 20, 20, 20
   | 21, 20, 30 |];

int: horizon = sum(i in BATCH, j in VAT)(p[i,j]);

%----------------------------
% Decision variables
%----------------------------
array[BATCH, VAT] of var 0..horizon: s;   % start times (scaled by 10)
array[BATCH, VAT] of var 0..horizon: e;   % end times   (scaled by 10)
var 0..horizon: makespan;

% Permutation flow shop: one common order of batches across all vats
array[1..nBatches] of var BATCH: order;
constraint all_different(order);

% Position of each batch in the permutation
array[BATCH] of var 1..nBatches: pos;
constraint all_different(pos);
constraint forall(k in 1..nBatches)( pos[order[k]] = k );

%----------------------------
% Constraints
%----------------------------
% Link start/end with processing times
constraint forall(i in BATCH, j in VAT)(
  e[i,j] = s[i,j] + p[i,j]
);

% Technological order within each batch: vat 1 -> 2 -> 3
constraint forall(i in BATCH, j in 1..nVats-1)(
  s[i,j+1] >= e[i,j]
);

% Capacity on each vat using the common permutation order
constraint forall(j in VAT, k in 1..nBatches-1)(
  s[order[k+1], j] >= e[order[k], j]
);

% Makespan
constraint makespan = max(i in BATCH)( e[i,nVats] );

%----------------------------
% Objective
%----------------------------
solve minimize makespan;

% Optional output (kept simple)
output [
  "makespan_scaled10 = ", show(makespan), "\n",
  "order = ", show(order), "\n"
];