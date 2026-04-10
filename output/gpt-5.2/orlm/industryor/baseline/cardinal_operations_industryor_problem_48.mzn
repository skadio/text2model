% Warehouse rental planning over 4 months
% All data embedded. MILP with integer and binary variables.

int: M = 4;
set of int: Months = 1..M;

set of int: L = 1..4; % contract lengths

array[Months] of int: demand = [1500, 1000, 2000, 1200]; % sqm required each month

% Rental fee per 100 sqm for a contract of length l (yuan)
array[L] of int: fee_per_100 = [4000, 7500, 10500, 13000];

% Convert to cost per sqm for length l
array[L] of int: cost_per_sqm = [ fee_per_100[l] div 100 | l in L ]; % [40,75,105,130] yuan/sqm

% Decision variables:
% x[s,l] = sqm rented via a contract starting at month s with length l (covers months s..s+l-1)
array[Months, L] of var 0..2000: x;

% Contract-usage indicator for (s,l): whether any positive area is rented with that contract
array[Months, L] of var bool: y;

% Length-used indicators: whether any contract of length l is used (any start month)
array[L] of var bool: useLen;

% Start feasibility: contract of length l can start at month s only if it fits in horizon
constraint forall(s in Months, l in L where s + l - 1 > M) (
  x[s,l] = 0 /\ y[s,l] = false
);

% Link x and y (big-M)
int: BigM = 2000; % max possible sqm needed in any month
constraint forall(s in Months, l in L where s + l - 1 <= M) (
  x[s,l] <= BigM * bool2int(y[s,l]) /\
  x[s,l] >= bool2int(y[s,l])  % if used, at least 1 sqm
);

% Define whether a length is used
constraint forall(l in L) (
  useLen[l] <-> exists(s in Months where s + l - 1 <= M)(y[s,l])
);

% Meet demand exactly each month: sum of active contracts covering month t equals demand[t]
constraint forall(t in Months) (
  sum(s in Months, l in L where s <= t /\ t <= s + l - 1)(x[s,l]) = demand[t]
);

% Business rule 2: at least two different contract lengths must be signed
constraint sum(l in L)(bool2int(useLen[l])) >= 2;

% Business rule 3: if any 4-month contract is chosen, then no 1-month contract may be chosen
constraint bool2int(useLen[4]) + bool2int(useLen[1]) <= 1;

% Business rule 4: at most 3 distinct warehouse contracts (distinct (start,length) pairs)
constraint sum(s in Months, l in L)(bool2int(y[s,l])) <= 3;

% Objective: minimize total cost
var int: total_cost =
  sum(s in Months, l in L where s + l - 1 <= M)(cost_per_sqm[l] * x[s,l]);

solve minimize total_cost;

output [
  "Minimum total rental cost (yuan): ", show(total_cost), "\n",
  "Contracts used (start_month, length, area_sqm):\n",
  concat([
    if fix(y[s,l]) then
      "  (" ++ show(s) ++ ", " ++ show(l) ++ ", " ++ show(fix(x[s,l])) ++ ")\n"
    else "" endif
    | s in Months, l in L where s + l - 1 <= M
  ]),
  "Lengths used: ",
  concat([ if fix(useLen[l]) then show(l) ++ " " else "" endif | l in L ]),
  "\n"
];