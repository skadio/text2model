int: T;
set of int: YEARS = 1..T;

array[YEARS] of int: Demand;
array[YEARS] of int: OilCap;

int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

int: U = max(Demand); % safe upper bound for yearly build amounts

array[YEARS] of var 0..U: BuildCoal;
array[YEARS] of var 0..U: BuildNuke;

array[YEARS] of var 0..sum(Demand): CoalCap;
array[YEARS] of var 0..sum(Demand): NukeCap;
array[YEARS] of var 0..sum(Demand): TotalCap;

constraint
  forall(t in YEARS) (
    CoalCap[t] =
      sum(i in YEARS where i <= t /\ t < i + CoalLife)(BuildCoal[i])
  );

constraint
  forall(t in YEARS) (
    NukeCap[t] =
      sum(i in YEARS where i <= t /\ t < i + NukeLife)(BuildNuke[i])
  );

constraint
  forall(t in YEARS) (
    TotalCap[t] = OilCap[t] + CoalCap[t] + NukeCap[t]
  );

constraint
  forall(t in YEARS) (
    TotalCap[t] >= Demand[t]
  );

% Nuclear capacity policy: per year, nuclear capacity cannot exceed MaxNuke
constraint
  forall(t in YEARS) (
    NukeCap[t] <= MaxNuke
  );

var int: TotalCost = CoalCost * sum(t in YEARS)(BuildCoal[t])
                   + NukeCost * sum(t in YEARS)(BuildNuke[t]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "BuildCoal=", show(BuildCoal), "\n",
  "BuildNuke=", show(BuildNuke), "\n",
  "CoalCap=", show(CoalCap), "\n",
  "NukeCap=", show(NukeCap), "\n",
  "TotalCap=", show(TotalCap), "\n"
];