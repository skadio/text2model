include "float.mzn";

int: A;
int: S;

set of int: ALLOYS = 1..A;
set of int: STEELS = 1..S;

array[ALLOYS] of float: AvailableAlloy;
array[ALLOYS] of float: CarbonContent;
array[ALLOYS] of float: NickelContent;
array[ALLOYS] of float: AlloyPrice;

array[STEELS] of float: SteelPrice;
array[STEELS] of float: CarbonMin;
array[STEELS] of float: NickelMax;

array[ALLOYS, STEELS] of var float: UseAlloyInSteel; % tons of alloy a used in steel s
array[STEELS] of var float: ProduceSteel;             % tons of steel s produced

constraint forall(a in ALLOYS, s in STEELS) (UseAlloyInSteel[a,s] >= 0.0);
constraint forall(s in STEELS) (ProduceSteel[s] >= 0.0);

% Mass balance: produced steel equals total alloy used in it
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(UseAlloyInSteel[a,s]) = ProduceSteel[s]
);

% Alloy availability
constraint forall(a in ALLOYS) (
  sum(s in STEELS)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
);

% Carbon minimum requirement (weighted average)
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(CarbonContent[a] * UseAlloyInSteel[a,s]) >= CarbonMin[s] * ProduceSteel[s]
);

% Nickel maximum requirement (weighted average)
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(NickelContent[a] * UseAlloyInSteel[a,s]) <= NickelMax[s] * ProduceSteel[s]
);

% At most 40% of alloy 1 in any steel type
constraint forall(s in STEELS) (
  UseAlloyInSteel[1,s] <= 0.4 * ProduceSteel[s]
);

% Profit = revenue - alloy purchase costs
var float: Profit =
  sum(s in STEELS)(SteelPrice[s] * ProduceSteel[s])
  - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * UseAlloyInSteel[a,s]);

solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "ProduceSteel=", show(ProduceSteel), "\n",
  "UseAlloyInSteel=\n",
  concat([ concat([ show(UseAlloyInSteel[a,s]) ++ if s==S then "\n" else " " endif
                  | s in STEELS ])
          | a in ALLOYS ])
];