include "globals.mzn";

% -----------------------
% Input data (from .dzn)
% -----------------------
int: T;                          % number of periods
int: K;                          % number of generator types
array[1..T] of int: Demand;      % demand in each period

array[1..K] of int: NumGenerator; % availability (units) of each type
array[1..K] of int: MinLevel;     % MW per unit when on (minimum)
array[1..K] of int: MaxLevel;     % MW per unit when on (maximum)

array[1..K] of int: RunCost;      % cost per hour per unit if on at minimum
array[1..K] of float: ExtraCost;  % extra cost per MW above minimum
array[1..K] of int: StartCost;    % startup cost per unit (when turned on)

% -----------------------
% Decision variables
% -----------------------
% on[t,k] = number of units of type k committed in period t
array[1..T, 1..K] of var 0..max(NumGenerator): on;
constraint forall(t in 1..T, k in 1..K)( on[t,k] <= NumGenerator[k] );

% p[t,k] = total MW produced by type k in period t (sum across committed units)
int: maxTotalGen = sum(k in 1..K)(NumGenerator[k] * MaxLevel[k]);
array[1..T, 1..K] of var 0..maxTotalGen: p;

% start[t,k] = number of units of type k started up at start of period t
array[1..T, 1..K] of var 0..max(NumGenerator): start;

% -----------------------
% Constraints
% -----------------------

% Demand must be met (allowing overproduction; change to "=" if required)
constraint forall(t in 1..T)(
  sum(k in 1..K)(p[t,k]) >= Demand[t]
);

% Production bounds conditional on commitment
constraint forall(t in 1..T, k in 1..K)(
  p[t,k] >= on[t,k] * MinLevel[k] /\
  p[t,k] <= on[t,k] * MaxLevel[k]
);

% Startup accounting: started units are increases in on between consecutive periods
constraint forall(k in 1..K)(
  start[1,k] = on[1,k]
);
constraint forall(t in 2..T, k in 1..K)(
  start[t,k] >= on[t,k] - on[t-1,k] /\
  start[t,k] >= 0
);
constraint forall(t in 1..T, k in 1..K)(
  start[t,k] <= NumGenerator[k]
);

% Hint-related "count" (redundant but included as per provided hint)
constraint forall(t in 1..T, k in 1..K) (
  count([on[t,k]], on[t,k], on[t,k])
);

% -----------------------
% Objective: minimize total cost
% -----------------------
% Running cost: RunCost per unit on at minimum
var float: totalRunCost =
  sum(t in 1..T, k in 1..K)( int2float(RunCost[k]) * int2float(on[t,k]) );

% Extra cost: ExtraCost per MW above minimum (across all committed units)
var float: totalExtraCost =
  sum(t in 1..T, k in 1..K)(
    ExtraCost[k] * ( int2float(p[t,k]) - int2float(on[t,k] * MinLevel[k]) )
  );

% Startup cost: StartCost per unit started
var float: totalStartCost =
  sum(t in 1..T, k in 1..K)( int2float(StartCost[k]) * int2float(start[t,k]) );

var float: totalCost = totalRunCost + totalExtraCost + totalStartCost;

solve minimize totalCost;

% -----------------------
% Output
% -----------------------
output [
  "TotalCost = ", show(totalCost), "\n",
  "RunCost   = ", show(totalRunCost), "\n",
  "ExtraCost = ", show(totalExtraCost), "\n",
  "StartCost = ", show(totalStartCost), "\n\n",
  "on = ", show(on), "\n",
  "p  = ", show(p), "\n",
  "start = ", show(start), "\n"
];