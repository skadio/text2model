include "globals.mzn";

%======================
% Input data
%======================
int: num_work;                 % number of works to cover
int: num_shifts;               % number of candidate shifts
int: min_num_shifts;           % minimum number of shifts required

% shifts[s] = set of works covered by shift s (works are numbered 1..num_work)
array[1..num_shifts] of set of 1..num_work: shifts;

%======================
% Decision variables
%======================
array[1..num_shifts] of var 0..1: use;   % use[s]=1 iff shift s is selected

%======================
% Constraints
%======================
% Each work must be covered by exactly one selected shift (set partitioning)
constraint
  forall(w in 1..num_work)(
    sum(s in 1..num_shifts)( use[s] * bool2int(w in shifts[s]) ) = 1
  );

% Optional: enforce a minimum number of shifts
constraint sum(s in 1..num_shifts)(use[s]) >= min_num_shifts;

%======================
% Objective
%======================
solve minimize sum(s in 1..num_shifts)(use[s]);

%======================
% Output
%======================
output [
  "num_shifts_used = ", show(sum(s in 1..num_shifts)(fix(use[s]))), "\n",
  "selected_shifts (1-based indices) = ",
  show([s | s in 1..num_shifts where fix(use[s]) = 1]), "\n"
];