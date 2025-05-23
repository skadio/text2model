% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Derived constants
int: MaxDemand = max(Demand);
int: MaxBuildPerYear = MaxDemand;
int: MaxTotalCap = T * MaxBuildPerYear;

% Variables
array[1..T] of var 0..MaxBuildPerYear: CoalBuild;
array[1..T] of var 0..MaxBuildPerYear: NukeBuild;

array[1..T] of var 0..MaxTotalCap: ActiveCoal;
array[1..T] of var 0..MaxTotalCap: ActiveNuke;

var int: TotalCost;

% Constraints
constraint
  forall(t in 1..T)(
    ActiveCoal[t] = sum([CoalBuild[tau] | tau in 1..t where t - tau < CoalLife])
  );

constraint
  forall(t in 1..T)(
    ActiveNuke[t] = sum([NukeBuild[tau] | tau in 1..t where t - tau < NukeLife])
  );

constraint
  forall(t in 1..T)(
    OilCap[t] + ActiveCoal[t] + ActiveNuke[t] >= Demand[t]
  );

constraint
  forall(t in 1..T)(
    ActiveNuke[t] <= MaxNuke
  );

constraint
  TotalCost = CoalCost * sum(t in 1..T)(CoalBuild[t]) +
              NukeCost * sum(t in 1..T)(NukeBuild[t]);

% Objective
solve minimize TotalCost;