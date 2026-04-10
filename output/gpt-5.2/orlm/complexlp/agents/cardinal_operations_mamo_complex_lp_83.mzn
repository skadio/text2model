% Parameters
int: n = 5;                                % Number of shops/locations
set of int: SHOPS = 1..n;                  % Index set for shops (1=Shop1,...,5=Shop5)

array[SHOPS, SHOPS] of int: cost =         % Travel cost matrix (cost[i,j])
  [|  0, 13, 87, 76, 50
   | 13,  0, 15, 65, 85
   | 87, 15,  0, 45, 81
   | 76, 65, 45,  0, 80
   | 50, 85, 81, 80,  0 |];

int: start = 1;                            % Starting (and ending) shop: Shop1

% Variables
array[SHOPS] of var SHOPS: succ;           % succ[i] = next shop visited after i
array[SHOPS] of var SHOPS: pred;           % pred[i] = previous shop visited before i
array[SHOPS] of var 0..n-1: pos;           % Position in tour (for symmetry breaking / ordering)
var 0..1000000: total_cost;                % Total travel cost (safe upper bound)

% Constraints
%--------------------------------------------------------------------
% Hamiltonian cycle structure: each shop has exactly one successor and
% exactly one predecessor.
%--------------------------------------------------------------------
constraint all_different(succ);
constraint all_different(pred);

% Inverse consistency between succ and pred:
% if j is the successor of i, then i is the predecessor of j.
constraint
  forall(i in SHOPS) (
    pred[succ[i]] = i
  );

%--------------------------------------------------------------------
% Fix the start shop position to break rotational symmetry.
%--------------------------------------------------------------------
constraint pos[start] = 0;

%--------------------------------------------------------------------
% Ordering constraints (position propagation along successor arcs).
% Together with all_different(succ), this enforces a single Hamiltonian
% cycle (positions wrap around modulo n).
%--------------------------------------------------------------------
constraint
  forall(i in SHOPS) (
    pos[succ[i]] = (pos[i] + 1) mod n
  );

%--------------------------------------------------------------------
% Total travel cost accumulation from successor arcs.
%--------------------------------------------------------------------
constraint
  total_cost = sum(i in SHOPS) ( cost[i, succ[i]] );

% Objective
solve minimize total_cost;