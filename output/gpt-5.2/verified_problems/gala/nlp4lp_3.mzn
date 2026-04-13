include "globals.mzn";

% =======================
% Input data (from .dzn)
% =======================
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;

int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% =======================
% Decision variables
% =======================
% New capacity established in year t (units)
array[1..T] of var 0..max(Demand): buildCoal;
array[1..T] of var 0..max(Demand): buildNuke;

% Available capacity in year t from coal/nuclear that are still within lifetime
array[1..T] of var 0..sum(Demand): coalCap;
array[1..T] of var 0..sum(Demand): nukeCap;

% =======================
% Capacity accounting with lifetimes
% =======================
% A build in year k contributes to years t where: k <= t <= k+Life-1
constraint
  forall(t in 1..T) (
    coalCap[t] =
      sum(k in 1..t where t - k < CoalLife)( buildCoal[k] )
  );

constraint
  forall(t in 1..T) (
    nukeCap[t] =
      sum(k in 1..t where t - k < NukeLife)( buildNuke[k] )
  );

% =======================
% Demand satisfaction
% =======================
constraint
  forall(t in 1..T) (
    OilCap[t] + coalCap[t] + nukeCap[t] >= Demand[t]
  );

% =======================
% Nuclear policy cap (absolute cap per year)
% =======================
constraint
  forall(t in 1..T) (
    nukeCap[t] <= MaxNuke
  );

% =======================
% Objective: minimize total capital cost of builds
% =======================
var int: totalCost =
  CoalCost * sum(t in 1..T)(buildCoal[t]) +
  NukeCost * sum(t in 1..T)(buildNuke[t]);

solve minimize totalCost;

% =======================
% Output
% =======================
output [
  "totalCost = ", show(totalCost), "\n",
  "buildCoal = ", show(buildCoal), "\n",
  "buildNuke = ", show(buildNuke), "\n",
  "coalCap   = ", show(coalCap), "\n",
  "nukeCap   = ", show(nukeCap), "\n",
  "totalCap  = ", show([OilCap[t] + coalCap[t] + nukeCap[t] | t in 1..T]), "\n"
];