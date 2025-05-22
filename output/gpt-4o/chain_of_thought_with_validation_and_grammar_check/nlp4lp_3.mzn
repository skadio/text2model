% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Helper constant for upper bounds
int: MaxDemand = max(Demand);

% Variables
array[1..T] of var 0..MaxDemand: BuildCoal;   % new coal capacity built in each year
array[1..T] of var 0..MaxDemand: BuildNuke;   % new nuclear capacity built in each year

% Constraints
%
% Capacity adequacy: in every year available capacity (oil + active coal + active nuclear) 
% must cover demand.
constraint
  forall(t in 1..T) (
      sum(s in 1..t where t - s < CoalLife) (BuildCoal[s]) +
      sum(s in 1..t where t - s < NukeLife) (BuildNuke[s]) +
      OilCap[t] >= Demand[t]
  );

% Nuclear share limit: total active nuclear capacity must never exceed MaxNuke.
constraint
  forall(t in 1..T) (
      sum(s in 1..t where t - s < NukeLife) (BuildNuke[s]) <= MaxNuke
  );

% Objective
var int: TotalCost = sum(t in 1..T) (
                        CoalCost * BuildCoal[t] +
                        NukeCost * BuildNuke[t]
                      );

solve minimize TotalCost;