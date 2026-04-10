int: A;
int: S;

array[1..A] of float: AvailableAlloy;
array[1..A] of float: CarbonContent;
array[1..A] of float: NickelContent;
array[1..A] of float: AlloyPrice;

array[1..S] of float: SteelPrice;
array[1..S] of float: CarbonMin;
array[1..S] of float: NickelMax;

array[1..A, 1..S] of var float: UseAlloyInSteel;  % tons of alloy a used in steel s
array[1..S] of var float: ProduceSteel;            % tons of steel s produced

constraint forall(a in 1..A, s in 1..S) (UseAlloyInSteel[a,s] >= 0.0);
constraint forall(s in 1..S) (ProduceSteel[s] >= 0.0);

% Material balance: produced steel equals sum of alloys used
constraint forall(s in 1..S) (
  ProduceSteel[s] = sum(a in 1..A)(UseAlloyInSteel[a,s])
);

% Alloy availability limits
constraint forall(a in 1..A) (
  sum(s in 1..S)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
);

% Quality constraints (handle ProduceSteel[s]=0 safely)
constraint forall(s in 1..S) (
  sum(a in 1..A)(CarbonContent[a] * UseAlloyInSteel[a,s]) >= CarbonMin[s] * ProduceSteel[s]
);

constraint forall(s in 1..S) (
  sum(a in 1..A)(NickelContent[a] * UseAlloyInSteel[a,s]) <= NickelMax[s] * ProduceSteel[s]
);

% At most 40% of alloy 1 in any steel type
constraint forall(s in 1..S) (
  UseAlloyInSteel[1,s] <= 0.40 * ProduceSteel[s]
);

% Profit maximization: revenue - raw material cost
var float: Profit =
  sum(s in 1..S)(SteelPrice[s] * ProduceSteel[s])
  - sum(a in 1..A, s in 1..S)(AlloyPrice[a] * UseAlloyInSteel[a,s]);

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "ProduceSteel = ", show(ProduceSteel), "\n",
  "UseAlloyInSteel =\n"
] ++
[
  "  alloy " ++ show(a) ++ ": " ++ show([UseAlloyInSteel[a,s] | s in 1..S]) ++ "\n"
  | a in 1..A
];