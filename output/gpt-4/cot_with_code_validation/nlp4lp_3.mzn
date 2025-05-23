% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Variables
array[1..T] of var 0..sum(Demand): CoalCap; % Coal capacity for each year
array[1..T] of var 0..MaxNuke: NukeCap; % Nuclear capacity for each year

% Constraints
constraint forall(t in 1..T)(
  CoalCap[t] + NukeCap[t] + OilCap[t] >= Demand[t] % Total capacity must meet demand
);

constraint forall(t in 1..T)(
  NukeCap[t] <= MaxNuke % Nuclear capacity must not exceed maximum
);

constraint forall(t in 1..T)(
  if t <= T - CoalLife + 1 then
    sum(i in t..min(t+CoalLife-1, T))(CoalCap[i]) >= CoalCap[t] % Coal plants produce at their capacity until the end of their lifetime
  endif
);

constraint forall(t in 1..T)(
  if t <= T - NukeLife + 1 then
    sum(i in t..min(t+NukeLife-1, T))(NukeCap[i]) >= NukeCap[t] % Nuclear plants produce at their capacity until the end of their lifetime
  endif
);

% Objective
var int: TotalCost = sum(t in 1..T)(CoalCap[t]*CoalCost + NukeCap[t]*NukeCost);
solve minimize TotalCost;