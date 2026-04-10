% Parameters
int: nBatches = 5;                 % number of fabric batches (jobs)
int: nVats = 3;                    % number of dyeing vats (machines) in fixed order 1..3

set of int: BATCHES = 1..nBatches; % batch index set
set of int: VATS = 1..nVats;       % vat index set (processing order)

array[BATCHES, VATS] of float: p = % processing time (hours) for batch i in vat j
  [| 3.0 , 1.0 , 1.0
   | 2.0 , 1.5 , 1.0
   | 3.0 , 1.2 , 1.3
   | 2.0 , 2.0 , 2.0
   | 2.1 , 2.0 , 3.0 |];

% A conservative upper bound on the makespan (sum of all processing times)
float: UB = sum(i in BATCHES, j in VATS)(p[i,j]);

% Variables
array[BATCHES, VATS] of var 0.0..UB: start;   % start time of batch i on vat j
array[BATCHES, VATS] of var 0.0..UB: finish;  % finish time of batch i on vat j
var 0.0..UB: makespan;                        % completion time of the last batch

% Constraints

%---------------------------------------------
% Timing definition: finish = start + processing time
%---------------------------------------------
constraint
  forall(i in BATCHES, j in VATS)(
    finish[i,j] = start[i,j] + p[i,j]
  );

%---------------------------------------------
% Technological order within each batch (flow through vats 1 -> 2 -> 3)
%---------------------------------------------
constraint
  forall(i in BATCHES, j in 1..nVats-1)(
    start[i,j+1] >= finish[i,j]
  );

%---------------------------------------------
% Non-overlap on each vat (each vat processes at most one batch at a time)
% Using disjunctive constraints via pairwise ordering for all batch pairs.
%---------------------------------------------
constraint
  forall(j in VATS, i1 in BATCHES, i2 in BATCHES where i1 < i2)(
    (start[i1,j] >= finish[i2,j]) \/ (start[i2,j] >= finish[i1,j])
  );

%---------------------------------------------
% Makespan definition: must be >= completion time of every batch on last vat
%---------------------------------------------
constraint
  forall(i in BATCHES)(
    makespan >= finish[i, nVats]
  );

% Objective
solve minimize makespan;