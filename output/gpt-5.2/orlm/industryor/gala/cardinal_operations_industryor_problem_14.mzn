include "globals.mzn";

% ----------------------------
% Data (embedded as requested)
% ----------------------------
int: n = 10;                                  % number of stages
array[1..n] of int: r = [3,5,2,4,6,5,4,3,2,1];% requirement at each stage

int: a = 10;  % buy new tool cost
int: b = 1;   % slow repair cost
int: c = 3;   % fast repair cost
int: p = 3;   % slow repair lead time (stages)
int: q = 1;   % fast repair lead time (stages)

% A safe upper bound on tools circulating (buy no more than total demand)
int: U = sum(j in 1..n)(r[j]);

% ----------------------------
% Decision variables
% ----------------------------
% buy[j] = new tools purchased and available at start of stage j
array[1..n] of var 0..U: buy;

% fs[j] = tools sent to fast repair at end of stage j (return at stage j+q)
array[1..n] of var 0..U: fast;

% sl[j] = tools sent to slow repair at end of stage j (return at stage j+p)
array[1..n] of var 0..U: slow;

% inv[j] = tools available at start of stage j
array[1..n] of var 0..U: inv;

% ----------------------------
% Constraints
% ----------------------------

% Inventory flow:
% inv[1] comes only from buying (no returns before stage 1)
constraint inv[1] = buy[1];

% For j>1, tools available = bought + returns from earlier repairs
constraint forall(j in 2..n)(
  inv[j] =
    buy[j]
    + (if j-q >= 1 then fast[j-q] else 0 endif)
    + (if j-p >= 1 then slow[j-p] else 0 endif)
);

% Must meet requirement each stage
constraint forall(j in 1..n)(inv[j] >= r[j]);

% After using r[j], remaining tools (inv[j]-r[j]) must be sent to repair
constraint forall(j in 1..n)(
  fast[j] + slow[j] = inv[j] - r[j]
);

% No reason to repair tools that would return after the horizon (tool not used after stage n)
constraint forall(j in 1..n where j + q > n)(fast[j] = 0);
constraint forall(j in 1..n where j + p > n)(slow[j] = 0);

% ----------------------------
% Objective
% ----------------------------
var int: total_cost =
  a * sum(j in 1..n)(buy[j]) +
  c * sum(j in 1..n)(fast[j]) +
  b * sum(j in 1..n)(slow[j]);

solve minimize total_cost;

% ----------------------------
% Output
% ----------------------------
output [
  "total_cost = ", show(total_cost), "\n",
  "buy  = ", show(buy), "\n",
  "fast = ", show(fast), "\n",
  "slow = ", show(slow), "\n",
  "inv  = ", show(inv), "\n"
];