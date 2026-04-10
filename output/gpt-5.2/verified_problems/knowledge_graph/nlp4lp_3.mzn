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

array[YEARS] of var 0..sum(Demand): CoalCap;
array[YEARS] of var 0..sum(Demand): NukeCap;
array[YEARS] of var 0..sum(Demand): TotalCap;

constraint
  forall(t in YEARS) (
    CoalCap[t] =
      sum(k in YEARS where k <= t /\ t - k < CoalLife)(BuildCoal[k])
  );

constraint
  forall(t in YEARS) (
    NukeCap[t] =
      sum(k in YEARS where k <= t /\ t - k < NukeLife)(BuildNuke[k])
  );

constraint
  forall(t in YEARS) (
    TotalCap[t] = OilCap[t] + CoalCap[t] + NukeCap[t]
  );

constraint
  forall(t in YEARS) (
    TotalCap[t] >= Demand[t]
  );

constraint
  forall(t in YEARS) (
    NukeCap[t] <= MaxNuke
  );

var int: TotalCost = CoalCost * sum(t in YEARS)(BuildCoal[t]) + NukeCost * sum(t in YEARS)(BuildNuke[t]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "BuildCoal=", show(BuildCoal), "\n",
  "BuildNuke=", show(BuildNuke), "\n",
  "CoalCap=", show(CoalCap), "\n",
  "NukeCap=", show(NukeCap), "\n",
  "TotalCap=", show(TotalCap), "\n"
];