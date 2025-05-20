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

% Variables
array[1..A, 1..S] of var 0..AvailableAlloy: AlloyInSteel; % Amount of each alloy in each steel type
array[1..S] of var 0..sum(AvailableAlloy): SteelProduced; % Amount of each steel type produced

% Constraints
constraint forall(a in 1..A)(sum(s in 1..S)(AlloyInSteel[a, s]) <= AvailableAlloy[a]); % Alloy availability constraint
constraint forall(s in 1..S)(sum(a in 1..A)(AlloyInSteel[a, s]) = SteelProduced[s]); % Steel production constraint
constraint forall(s in 1..S)(sum(a in 1..A)(AlloyInSteel[a, s] * CarbonContent[a]) / SteelProduced[s] >= CarbonMin[s]); % Carbon content constraint
constraint forall(s in 1..S)(sum(a in 1..A)(AlloyInSteel[a, s] * NickelContent[a]) / SteelProduced[s] <= NickelMax[s]); % Nickel content constraint
constraint forall(s in 1..S)(AlloyInSteel[1, s] / SteelProduced[s] <= 0.4); % Alloy 1 constraint

% Objective
var int: Profit = sum(s in 1..S)(SteelPrice[s] * SteelProduced[s]) - sum(a in 1..A, s in 1..S)(AlloyPrice[a] * AlloyInSteel[a, s]);
solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++
["AlloyInSteel: ", show(AlloyInSteel), "\n"] ++
["SteelProduced: ", show(SteelProduced), "\n"];