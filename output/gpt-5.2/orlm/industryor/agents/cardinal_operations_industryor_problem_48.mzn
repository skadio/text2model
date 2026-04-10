% Parameters
int: nMonths = 4;                          % planning horizon (months)
set of int: MONTHS = 1..nMonths;

int: nTypes = 4;                           % contract length types: 1..4 months
set of int: TYPES = 1..nTypes;

array[MONTHS] of int: required_area =      % required warehouse area per month (m^2)
  [1500, 1000, 2000, 1200];

array[TYPES] of int: contract_len =        % contract length in months for each type
  [1, 2, 3, 4];

array[TYPES] of int: fee_per_100sqm =      % rental fee per 100 m^2 for each contract length
  [4000, 7500, 10500, 13000];

int: area_unit = 100;                      % costing is per 100 m^2

% Upper bound on #contracts of a type (at most one per possible start month for that length)
array[TYPES] of int: max_contracts_of_type =
  [nMonths - contract_len[t] + 1 | t in TYPES];

int: max_distinct_contracts = 3;           % at most 3 distinct contracts (type/start combos)

% Variables
% x_start[t,s] = number of contracts of type t starting at month s
% (declared for all months; infeasible (t,s) are constrained to 0)
array[TYPES, MONTHS] of var 0..max(max_contracts_of_type): x_start;

% used_start[t,s] = 1 if at least one contract of type t starts at month s
array[TYPES, MONTHS] of var bool: used_start;

% usedLen[t] = 1 if any contract of length/type t is used anywhere
array[TYPES] of var bool: usedLen;

% Total cost (yuan); safe upper bound via 1-month contracts for all demand blocks
var 0..(sum(m in MONTHS)(required_area[m] div area_unit) * fee_per_100sqm[1]): total_cost;


% Constraints

%-------------------------------
% Feasibility of start months
%-------------------------------
% Infeasible (type, start) pairs must be zero (contract would extend beyond horizon).
constraint
  forall(t in TYPES, s in MONTHS where s + contract_len[t] - 1 > nMonths) (
    x_start[t,s] = 0 /\
    used_start[t,s] = false
  );

%-------------------------------
% Link x_start and used_start
%-------------------------------
% used_start[t,s] is true iff at least one contract of that (type,start) is signed.
constraint
  forall(t in TYPES, s in MONTHS where s + contract_len[t] - 1 <= nMonths) (
    x_start[t,s] >= bool2int(used_start[t,s])
  );

% If not used, then zero contracts (big-M).
constraint
  forall(t in TYPES, s in MONTHS where s + contract_len[t] - 1 <= nMonths) (
    x_start[t,s] <= max_contracts_of_type[t] * bool2int(used_start[t,s])
  );

%-------------------------------
% Distinct contract-count limit
%-------------------------------
% Number of distinct (type,start) contract variants used cannot exceed max_distinct_contracts.
constraint
  sum(t in TYPES, s in MONTHS)(bool2int(used_start[t,s])) <= max_distinct_contracts;

%-------------------------------
% Link usedLen (length/type usage)
%-------------------------------
% usedLen[t] is true iff any contract of type t is used at any start month.
constraint
  forall(t in TYPES) (
    sum(s in MONTHS)(bool2int(used_start[t,s])) >= bool2int(usedLen[t])
  );

constraint
  forall(t in TYPES) (
    sum(s in MONTHS)(bool2int(used_start[t,s])) <= card(MONTHS) * bool2int(usedLen[t])
  );

%-------------------------------
% Risk management: at least two different lengths used
%-------------------------------
constraint
  sum(t in TYPES)(bool2int(usedLen[t])) >= 2;

%-------------------------------
% Mutual exclusion: 4-month vs 1-month contracts
%-------------------------------
constraint
  bool2int(usedLen[1]) + bool2int(usedLen[4]) <= 1;

%-------------------------------
% Demand satisfaction (exactly, no shortage or excess)
%-------------------------------
% Each contract contributes its x_start[t,s] blocks of 100m^2 in each covered month.
constraint
  forall(m in MONTHS) (
    sum(t in TYPES, s in MONTHS where s + contract_len[t] - 1 <= nMonths /\ s <= m /\ m <= s + contract_len[t] - 1)
      (x_start[t,s]) * area_unit
    = required_area[m]
  );

%-------------------------------
% Total cost definition
%-------------------------------
constraint
  total_cost =
    sum(t in TYPES, s in MONTHS where s + contract_len[t] - 1 <= nMonths) (
      x_start[t,s] * fee_per_100sqm[t]
    );


% Objective
solve minimize total_cost;