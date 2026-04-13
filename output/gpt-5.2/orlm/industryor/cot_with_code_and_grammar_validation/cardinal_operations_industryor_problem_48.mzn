% Parameters
int: NMONTHS = 4;
set of int: M = 1..NMONTHS;

int: NTYPES = 4;
set of int: T = 1..NTYPES;

array[M] of int: demand = [1500, 1000, 2000, 1200]; % sqm required each month
array[T] of int: len = [1, 2, 3, 4];                % contract lengths in months
array[T] of int: fee_per_100sqm = [4000, 7500, 10500, 13000]; % yuan per 100 sqm per contract

int: unit = 100; % sqm per fee unit

% coverage[t,m] = 1 if a contract of type t covers month m (contracts must start at month 1)
array[T, M] of int: cover =
  array2d(T, M,
    [ if m <= len[t] then 1 else 0 endif
      | t in T, m in M ]);

% Variables
array[T] of var 0..100000: x;         % number of contracts of each type (scaled to 100 sqm units)
array[T] of var bool: use;            % whether contract type is used

var int: total_cost;

% Constraints
% Link use[t] with x[t]
constraint forall(t in T) (
  x[t] >= 1 * bool2int(use[t])
);

constraint forall(t in T) (
  x[t] <= 100000 * bool2int(use[t])
);

% Demand satisfaction exactly (no shortage, no excess), in 100 sqm units
% (Assumes demand values are multiples of 100; they are in this instance.)
constraint forall(m in M) (
  sum(t in T)( cover[t,m] * x[t] ) = demand[m] div unit
);

% At least two different contract lengths must be used
constraint sum(t in T)(bool2int(use[t])) >= 2;

% Mutual exclusion: if 4-month contract chosen then no 1-month contract chosen
constraint bool2int(use[4]) + bool2int(use[1]) <= 1;

% Number of distinct contract types used cannot exceed 3
constraint sum(t in T)(bool2int(use[t])) <= 3;

% Total cost
constraint total_cost = sum(t in T)( fee_per_100sqm[t] * x[t] );

% Objective
solve minimize total_cost;