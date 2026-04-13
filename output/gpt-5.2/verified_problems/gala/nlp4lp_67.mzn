include "globals.mzn";

%======================
% Input data (.dzn)
%======================
int: M;                               % number of roll types (width options)
int: N;                               % number of cutting patterns
int: large_roll_width;                % not required for feasibility if patterns are prevalidated
array[1..M] of int: demands;          % demand for each roll type
array[1..M] of float: roll_width_options; % widths (informational)
array[1..N, 1..M] of int: patterns;   % patterns[p,t] = pieces of type t produced by pattern p

%======================
% Derived bounds
%======================
% A safe upper bound: if we produced everything using single-piece rolls,
% we would need at most sum(demands) large rolls (since each roll produces >= 1 piece).
int: UB = sum(demands);

%======================
% Decision variables
%======================
array[1..N] of var 0..UB: use;        % how many large rolls are cut with pattern p

%======================
% Constraints: meet all demands
%======================
constraint
  forall(t in 1..M) (
    sum(p in 1..N) (use[p] * patterns[p,t]) >= demands[t]
  );

%======================
% Objective: minimize total large rolls used
%======================
var 0..UB: total_rolls = sum(p in 1..N)(use[p]);

solve minimize total_rolls;

%======================
% Output
%======================
output [
  "Total large rolls used = ", show(total_rolls), "\n",
  "Pattern usage (use[p]) = ", show(use), "\n"
];