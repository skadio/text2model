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

array[ALLOYS, STEELS] of var float: UseAlloyInSteel;
array[STEELS] of var float: SteelProduced;

constraint forall(a in ALLOYS, s in STEELS) (
  UseAlloyInSteel[a,s] >= 0.0
);

constraint forall(s in STEELS) (
  SteelProduced[s] >= 0.0
);

constraint forall(a in ALLOYS) (
  sum(s in STEELS)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
);

constraint forall(s in STEELS) (
  SteelProduced[s] = sum(a in ALLOYS)(UseAlloyInSteel[a,s])
);

constraint forall(s in STEELS) (
  sum(a in ALLOYS)(CarbonContent[a] * UseAlloyInSteel[a,s]) >= CarbonMin[s] * SteelProduced[s]
);

constraint forall(s in STEELS) (
  sum(a in ALLOYS)(NickelContent[a] * UseAlloyInSteel[a,s]) <= NickelMax[s] * SteelProduced[s]
);

constraint forall(s in STEELS) (
  UseAlloyInSteel[1,s] <= 0.4 * SteelProduced[s]
);

solve maximize
  sum(s in STEELS)(SteelPrice[s] * SteelProduced[s])
  - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * UseAlloyInSteel[a,s]);