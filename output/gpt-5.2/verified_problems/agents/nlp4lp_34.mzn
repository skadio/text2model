% Parameters
int: T; % total number of periods
int: K; % total number of generator types

set of int: PERIODS = 1..T;
set of int: GENTYPES = 1..K;

array[PERIODS] of int: Demand;         % electricity demand in period t
array[GENTYPES] of int: NumGenerator;  % number available of generator type k
array[GENTYPES] of int: MinLevel;      % minimum production level (MW) for type k
array[GENTYPES] of int: MaxLevel;      % maximum production level (MW) for type k
array[GENTYPES] of int: RunCost;       % hourly cost for running type k at minimum level
array[GENTYPES] of float: ExtraCost;   % extra hourly cost per MW above minimum for type k
array[GENTYPES] of int: StartCost;     % start-up cost for type k

% Helpful derived bound for MW above minimum (not a decision variable)
array[GENTYPES] of int: MaxAboveMin = [MaxLevel[k] - MinLevel[k] | k in GENTYPES];

% Variables
array[GENTYPES, PERIODS] of var 0..max(NumGenerator): on;
% number of generators of type k that are ON in period t

array[GENTYPES, PERIODS] of var 0..max(NumGenerator): start;
% number of generators of type k started in period t

array[GENTYPES, PERIODS] of var 0..(max(NumGenerator) * max(MaxAboveMin)): aboveMinMW;
% total MW produced above minimum by type k in period t (aggregate over units)

array[GENTYPES, PERIODS] of var 0..(max(NumGenerator) * max(MaxLevel)): productionMW;
% total MW produced by type k in period t (aggregate over units)

% Constraints
% Basic availability bounds
constraint forall(k in GENTYPES, t in PERIODS) (
  on[k,t] <= NumGenerator[k]
);

constraint forall(k in GENTYPES, t in PERIODS) (
  start[k,t] <= NumGenerator[k]
);

% Above-minimum production limited by committed units
constraint forall(k in GENTYPES, t in PERIODS) (
  aboveMinMW[k,t] <= on[k,t] * (MaxLevel[k] - MinLevel[k])
);

% Link production to commitment and above-minimum generation
constraint forall(k in GENTYPES, t in PERIODS) (
  productionMW[k,t] >= on[k,t] * MinLevel[k] /\
  productionMW[k,t] <= on[k,t] * MaxLevel[k] /\
  productionMW[k,t] = on[k,t] * MinLevel[k] + aboveMinMW[k,t]
);

% Demand satisfaction: total generation across all types must meet demand each period
constraint forall(t in PERIODS) (
  sum(k in GENTYPES)(productionMW[k,t]) >= Demand[t]
);

% Start-up logic: starts capture increases in committed units between consecutive periods
constraint forall(k in GENTYPES, t in PERIODS where t > 1) (
  start[k,t] >= on[k,t] - on[k,t-1]
);

% Initial period start-up logic: all units that are ON in period 1 are considered started
constraint forall(k in GENTYPES) (
  start[k,1] = on[k,1]
);

% Tighten start variables: cannot start more units than are on in the same period
constraint forall(k in GENTYPES, t in PERIODS) (
  start[k,t] <= on[k,t]
);

% Objective
solve minimize
  sum(k in GENTYPES, t in PERIODS)(
      RunCost[k] * on[k,t]
    + ExtraCost[k] * aboveMinMW[k,t]
    + StartCost[k] * start[k,t]
  );