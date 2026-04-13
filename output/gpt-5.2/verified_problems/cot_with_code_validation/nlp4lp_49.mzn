% Steel alloy blending optimization (linear model)

% Parameters
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

% Decision variables
array[ALLOYS, STEELS] of var float: UseAlloyInSteel;  % tons of alloy a used in steel s
array[STEELS] of var float: SteelProduced;            % tons of steel s produced
var float: Profit;

% Constraints

% Non-negativity
constraint forall(a in ALLOYS, s in STEELS) (UseAlloyInSteel[a,s] >= 0.0);
constraint forall(s in STEELS) (SteelProduced[s] >= 0.0);

% Availability of alloys
constraint forall(a in ALLOYS) (
  sum(s in STEELS)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
);

% Mass balance: produced steel equals sum of alloys used
constraint forall(s in STEELS) (
  SteelProduced[s] = sum(a in ALLOYS)(UseAlloyInSteel[a,s])
);

% Carbon minimum requirement
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(CarbonContent[a] * UseAlloyInSteel[a,s])
  >= CarbonMin[s] * SteelProduced[s]
);

% Nickel maximum requirement
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(NickelContent[a] * UseAlloyInSteel[a,s])
  <= NickelMax[s] * SteelProduced[s]
);

% At most 40% of alloy 1 in any steel
constraint forall(s in STEELS) (
  UseAlloyInSteel[1,s] <= 0.4 * SteelProduced[s]
);

% Profit definition: revenue - cost
constraint
  Profit =
    sum(s in STEELS)(SteelPrice[s] * SteelProduced[s])
    - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * UseAlloyInSteel[a,s]);

% Objective
solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "SteelProduced = ", show(SteelProduced), "\n",
  "UseAlloyInSteel = ", show(UseAlloyInSteel), "\n"
];