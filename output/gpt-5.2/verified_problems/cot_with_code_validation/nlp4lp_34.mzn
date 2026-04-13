% Unit Commitment / Economic Dispatch (by generator type)

%-----------------------
% Parameters
%-----------------------
int: T;                     % number of periods
int: K;                     % number of generator types

array[1..T] of int: Demand;

array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;

array[1..K] of int: RunCost;        % cost per unit online per period (at min output)
array[1..K] of float: ExtraCost;    % cost per MW above min
array[1..K] of int: StartCost;      % cost per unit started

%-----------------------
% Decision Variables
%-----------------------
array[1..T, 1..K] of var 0..max(NumGenerator): On;       % units online of type k in period t
array[1..T, 1..K] of var 0..max(NumGenerator): Start;    % units started of type k in period t

% Total MW produced by type k in period t
array[1..T, 1..K] of var 0..(max(NumGenerator) * max(MaxLevel)): Gen;

%-----------------------
% Constraints
%-----------------------
constraint forall(k in 1..K) (MinLevel[k] <= MaxLevel[k]);

constraint forall(t in 1..T, k in 1..K) (
  On[t,k] <= NumGenerator[k] /\
  Start[t,k] <= NumGenerator[k]
);

% Generation bounds when units are online
constraint forall(t in 1..T, k in 1..K) (
  Gen[t,k] >= MinLevel[k] * On[t,k] /\
  Gen[t,k] <= MaxLevel[k] * On[t,k]
);

% Meet demand each period
constraint forall(t in 1..T) (
  sum(k in 1..K)(Gen[t,k]) >= Demand[t]
);

% Startup accounting (starts cover increases in online units; no shutdown cost modeled)
constraint forall(k in 1..K) (
  Start[1,k] >= On[1,k]
);
constraint forall(t in 2..T, k in 1..K) (
  Start[t,k] >= On[t,k] - On[t-1,k]
);

% Nonnegativity already ensured by domains, but keep explicit for clarity
constraint forall(t in 1..T, k in 1..K) (Start[t,k] >= 0);

%-----------------------
% Objective
%-----------------------
var float: TotalCost =
  sum(t in 1..T, k in 1..K)(
      int2float(RunCost[k]) * int2float(On[t,k])
    + ExtraCost[k] * (int2float(Gen[t,k]) - int2float(MinLevel[k]) * int2float(On[t,k]))
  )
  + sum(t in 1..T, k in 1..K)(
      int2float(StartCost[k]) * int2float(Start[t,k])
  );

solve minimize TotalCost;