int: T;
set of int: YEARS = 1..T;

array[YEARS] of int: Demand;
array[YEARS] of int: OilCap;

int: CoalCost;
int: NukeCost;

int: MaxNuke;

int: CoalLife;
int: NukeLife;

array[YEARS] of var 0..max(Demand): BuildCoal;
array[YEARS] of var 0..max(Demand): BuildNuke;

array[YEARS] of var 0..sum(Demand): CoalAvail;
array[YEARS] of var 0..sum(Demand): NukeAvail;

constraint
  forall(t in YEARS) (
    CoalAvail[t] =
      sum(k in YEARS where (k <= t /\ t < k + CoalLife)) (BuildCoal[k])
  );

constraint
  forall(t in YEARS) (
    NukeAvail[t] =
      sum(k in YEARS where (k <= t /\ t < k + NukeLife)) (BuildNuke[k])
  );

constraint
  forall(t in YEARS) (
    OilCap[t] + CoalAvail[t] + NukeAvail[t] >= Demand[t]
  );

constraint
  forall(t in YEARS) (
    NukeAvail[t] <= MaxNuke
  );

solve minimize sum(t in YEARS) (CoalCost * BuildCoal[t] + NukeCost * BuildNuke[t]);