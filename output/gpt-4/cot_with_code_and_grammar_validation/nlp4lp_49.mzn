% Parameters
int: A; % Total number of different alloys
int: S; % Total number of different steel types
array[1..A] of int: AvailableAlloy; % Available amount of alloy a
array[1..A] of float: CarbonContent; % Carbon content of alloy a
array[1..A] of float: NickelContent; % Nickel content of alloy a
array[1..A] of int: AlloyPrice; % Price of alloy a
array[1..S] of int: SteelPrice; % Price of steel type s
array[1..S] of float: CarbonMin; % Minimum required carbon content for steel type s
array[1..S] of float: NickelMax; % Maximum allowed nickel content for steel type s

% Variables
array[1..S, 1..A] of var 0..AvailableAlloy[A]: SteelAlloy; % Amount of alloy a used in steel type s
array[1..S] of var 0..sum(AvailableAlloy): SteelProduced; % Amount of steel type s produced

% Constraints
constraint forall(s in 1..S)(
  sum(a in 1..A)(SteelAlloy[s, a]) = SteelProduced[s]
);

constraint forall(s in 1..S)(
  sum(a in 1..A)(SteelAlloy[s, a]*CarbonContent[a]) >= CarbonMin[s]*SteelProduced[s]
);

constraint forall(s in 1..S)(
  sum(a in 1..A)(SteelAlloy[s, a]*NickelContent[a]) <= NickelMax[s]*SteelProduced[s]
);

constraint forall(s in 1..S)(
  SteelAlloy[s, 1] <= 0.4*SteelProduced[s]
);

constraint forall(a in 1..A)(
  sum(s in 1..S)(SteelAlloy[s, a]) <= AvailableAlloy[a]
);

% Objective
var int: Profit = sum(s in 1..S)(SteelPrice[s]*SteelProduced[s]) - sum(a in 1..A, s in 1..S)(AlloyPrice[a]*SteelAlloy[s, a]);
solve maximize Profit;