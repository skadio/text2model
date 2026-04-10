% Warehouse rental MILP (4 months)
% Data embedded as per problem statement.

int: T = 4;
set of int: MONTHS = 1..T;
set of int: LENS = 1..4;

array[MONTHS] of int: demand = [1500, 1000, 2000, 1200];      % m^2
array[LENS] of int: fee_per_100 = [4000, 7500, 10500, 13000]; % yuan per 100 m^2 for an L-month contract

int: max_contract_types = 3;
int: min_contract_types = 2;

% Tight but safe bounds for area variables:
int: max_month_demand = max(demand);     % 2000
int: max_total_demand = sum(demand);     % 5700

% Decision variables
% x[s,l] = area (m^2) rented via a contract of length l starting at month s
array[MONTHS, LENS] of var 0..max_month_demand: x;

% y[s,l] = 1 if x[s,l] > 0 (contract type used at that start)
array[MONTHS, LENS] of var bool: y;

% used_len[l] = 1 if any contract of length l is used anywhere
array[LENS] of var bool: used_len;

% Total cost in "yuan * m^2 / 100" units to keep everything integral.
% (Since fees are per 100 m^2, cost is integral when areas are in m^2.)
var 0..(max_total_demand * max(fee_per_100)): total_cost100;

% -------------------------------------------------------------------
% Constraints

% Disallow contracts that do not fit fully in the horizon
constraint
  forall(s in MONTHS, l in LENS where s + l - 1 > T) (
    x[s,l] = 0 /\ y[s,l] = false
  );

% Link x and y (Big-M)
constraint
  forall(s in MONTHS, l in LENS where s + l - 1 <= T) (
    x[s,l] <= max_month_demand * bool2int(y[s,l])
  );

% Monthly demand must be met exactly
constraint
  forall(t in MONTHS) (
    sum(s in MONTHS, l in LENS where s + l - 1 <= T /\ s <= t /\ t <= s + l - 1) (x[s,l]) = demand[t]
  );

% Define used_len: true iff any y[s,l] is true for that length
constraint
  forall(l in LENS) (
    used_len[l] <-> exists(s in MONTHS where s + l - 1 <= T)( y[s,l] )
  );

% At least two different contract lengths
constraint sum(l in LENS)(bool2int(used_len[l])) >= min_contract_types;

% No more than three different contract lengths
constraint sum(l in LENS)(bool2int(used_len[l])) <= max_contract_types;

% Mutual exclusion: if any 4-month contract is chosen, then no 1-month contract may be chosen
constraint bool2int(used_len[4]) + bool2int(used_len[1]) <= 1;

% Objective: total_cost100 = sum fee_per_100[l] * area
constraint
  total_cost100 =
    sum(s in MONTHS, l in LENS where s + l - 1 <= T) ( fee_per_100[l] * x[s,l] );

solve minimize total_cost100;

output
  [
    "Minimum total rental cost (yuan) = ",
    show(total_cost100 div 100), if total_cost100 mod 100 = 0 then "" else "." ++ show(total_cost100 mod 100) endif,
    "\n",
    "total_cost100 (yuan* m^2 /100) = ", show(total_cost100), "\n",
    "x[s,l] (area m^2):\n"
  ]
  ++
  [
    (if s + l - 1 <= T then
       "  start " ++ show(s) ++ ", len " ++ show(l) ++ ": area=" ++ show(x[s,l]) ++ ", used=" ++ show(y[s,l]) ++ "\n"
     else "" endif)
    | s in MONTHS, l in LENS
  ]
  ++
  [
    "Used lengths (l=1..4): ", show([bool2int(used_len[l]) | l in LENS]), "\n"
  ];