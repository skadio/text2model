include "globals.mzn";

%--- Data -------------------------------------------------------------
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

%--- Derived constants -------------------------------------------------
int: MaxDemand = max(Demand);

%--- Decision variables ------------------------------------------------
array[1..T] of var 0..MaxDemand : coal_build;   % new coal capacity each year
array[1..T] of var 0..MaxDemand : nuke_build;   % new nuclear capacity each year

%--- Nuclear cumulative constraint ------------------------------------
array[1..T] of int: nuke_start = [i | i in 1..T];
array[1..T] of int: nuke_dur   = [NukeLife | i in 1..T];
constraint cumulative(nuke_start, nuke_dur, nuke_build, MaxNuke);

%--- Capacity in each year -------------------------------------------
array[1..T] of var int: coal_cap;
array[1..T] of var int: nuke_cap;

constraint forall(t in 1..T) (
  coal_cap[t] = sum([coal_build[s] | s in 1..T where s <= t /\ t - s < CoalLife])
);
constraint forall(t in 1..T) (
  nuke_cap[t] = sum([nuke_build[s] | s in 1..T where s <= t /\ t - s < NukeLife])
);

%--- Demand satisfaction ----------------------------------------------
constraint forall(t in 1..T) (
  OilCap[t] + coal_cap[t] + nuke_cap[t] >= Demand[t]
);

%--- Objective ---------------------------------------------------------
var int: totalCost = sum(t in 1..T) (coal_build[t] * CoalCost + nuke_build[t] * NukeCost);
solve minimize totalCost;

%--- Output ------------------------------------------------------------
output [
  "Total cost: ", show(totalCost), "\n",
  "Year\tCoalBuild\tNukeBuild\tCoalCap\tNukeCap\tOilCap\tDemand\n",
  concat([ show(t) ^ "\t" ^ show(coal_build[t]) ^ "\t" ^ show(nuke_build[t]) ^ "\t" ^
          show(coal_cap[t]) ^ "\t" ^ show(nuke_cap[t]) ^ "\t" ^ show(OilCap[t]) ^ "\t" ^ show(Demand[t]) ^ "\n"
          | t in 1..T ])
];