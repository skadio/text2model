% Tool purchase and repair planning (embedded data)

% Parameters
int: n = 10;                                  % number of stages
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1];  % demand per stage
int: a = 10;                                  % cost to buy new tool
int: b = 1;                                   % cost slow repair
int: c = 3;                                   % cost fast repair
int: p = 3;                                   % slow repair duration (stages)
int: q = 1;                                   % fast repair duration (stages)

int: Rsum = sum(j in 1..n)(r[j]);
int: UBcost = a*Rsum + max(b,c)*Rsum*n;

% Decision variables
array[1..n] of var 0..Rsum: buy;              % new tools purchased at stage j
array[1..n] of var 0..Rsum: slow;             % tools sent to slow repair after stage j
array[1..n] of var 0..Rsum: fast;             % tools sent to fast repair after stage j
array[0..n] of var 0..Rsum: inv;              % inventory available at start of stage t
var 0..UBcost: total_cost;

% Initial inventory
constraint inv[0] = 0;

% All used tools of stage j must be sent to repair (slow or fast)
constraint forall(j in 1..n)(
  slow[j] + fast[j] = r[j]
);

% Inventory balance across stages (use stage-by-stage availability)
constraint forall(t in 1..n)(
  inv[t] =
    inv[t-1]
    + buy[t]
    + (if t-q >= 1 then fast[t-q] else 0 endif)
    + (if t-p >= 1 then slow[t-p] else 0 endif)
    - r[t]
);

% Meet demand each stage (redundant given inv[t] domain, but helps propagation)
constraint forall(t in 1..n)(
  inv[t-1]
  + buy[t]
  + (if t-q >= 1 then fast[t-q] else 0 endif)
  + (if t-p >= 1 then slow[t-p] else 0 endif)
  >= r[t]
);

% Objective
constraint total_cost =
    a * sum(j in 1..n)(buy[j])
  + b * sum(j in 1..n)(slow[j])
  + c * sum(j in 1..n)(fast[j]);

% Speed-up: search on purchases/repairs rather than inventory variables
solve :: int_search([buy[j] | j in 1..n] ++ [fast[j] | j in 1..n], first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "buy  = ", show(buy), "\n",
  "fast = ", show(fast), "\n",
  "slow = ", show(slow), "\n",
  "inv  = ", show(inv), "\n"
];