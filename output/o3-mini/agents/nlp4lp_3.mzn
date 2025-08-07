include "globals.mzn";

% Data
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;

int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Decision variables: the new capacity built in each period (in units)
array[1..T] of var 0..1000: coalBuild;
array[1..T] of var 0..1000: nukeBuild;

% Helper functions to correctly compute the starting period for capacity that is still active.
function int: startCoal(int: t) =
    if t - CoalLife + 1 < 1 then 1 else t - CoalLife + 1 endif;

function int: startNuke(int: t) =
    if t - NukeLife + 1 < 1 then 1 else t - NukeLife + 1 endif;

% Constraints:
% For each period t, the available capacity is the sum of:
% - Oil-fired capacity that is permanently available (OilCap)
% - Coal capacity built within its lifetime: periods startCoal(t) .. t
% - Nuclear capacity built within its lifetime: periods startNuke(t) .. t
%
% This total must be at least the forecasted demand.
constraint
  forall(t in 1..T) (
    OilCap[t]
    + sum(k in startCoal(t)..t)( coalBuild[k] )
    + sum(k in startNuke(t)..t)( nukeBuild[k] )
    >= Demand[t]
  );

% In every period, the nuclear capacity available (plants still operating)
% must not exceed MaxNuke.
constraint
  forall(t in 1..T) (
    sum(k in startNuke(t)..t)( nukeBuild[k] ) <= MaxNuke
  );

% Objective: minimize the total capital cost
solve minimize sum(t in 1..T)( CoalCost * coalBuild[t] + NukeCost * nukeBuild[t] );

% Output
output [
  "Total cost = ", show(sum(t in 1..T)( CoalCost * coalBuild[t] + NukeCost * nukeBuild[t])), "\n",
  "Coal builds = ", show(coalBuild), "\n",
  "Nuclear builds = ", show(nukeBuild), "\n"
];