include "globals.mzn";

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

% Decision variables
array[1..S, 1..A] of var 0..AvailableAlloy: SteelAlloy; % Amount of each alloy in each steel type
array[1..S] of var 0..sum(AvailableAlloy): SteelProduced; % Amount of each steel type produced

% Objective
var int: profit = sum(s in 1..S) (SteelPrice[s] * SteelProduced[s]) - sum(a in 1..A) (AlloyPrice[a] * sum(s in 1..S) (SteelAlloy[s, a]));
maximize profit;

% Constraints
constraint forall(s in 1..S) (
  sum(a in 1..A) (SteelAlloy[s, a]) = SteelProduced[s]
);

constraint forall(s in 1..S) (
  sum(a in 1..A) (CarbonContent[a] * SteelAlloy[s, a]) / SteelProduced[s] >= CarbonMin[s]
);

constraint forall(s in 1..S) (
  sum(a in 1..A) (NickelContent[a] * SteelAlloy[s, a]) / SteelProduced[s] <= NickelMax[s]
);

constraint forall(s in 1..S) (
  SteelAlloy[s, 1] / SteelProduced[s] <= 0.4
);

constraint forall(a in 1..A) (
  sum(s in 1..S) (SteelAlloy[s, a]) <= AvailableAlloy[a]
);

solve satisfy;