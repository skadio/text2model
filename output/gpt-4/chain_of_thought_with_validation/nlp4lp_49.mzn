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
array[1..S, 1..A] of var 0..max(AvailableAlloy): SteelAlloy; % Amount of alloy a used in steel type s
array[1..S] of var 0..sum(AvailableAlloy): SteelProduced; % Amount of steel type s produced

% Constraints
constraint forall(s in 1..S)(sum(a in 1..A)(SteelAlloy[s, a]) = SteelProduced[s]); % The total amount of alloys used in a steel type equals the amount of steel produced
constraint forall(s in 1..S)(sum(a in 1..A)(SteelAlloy[s, a] * CarbonContent[a]) / SteelProduced[s] >= CarbonMin[s]); % The carbon content of each steel type must be at least the minimum required
constraint forall(s in 1..S)(sum(a in 1..A)(SteelAlloy[s, a] * NickelContent[a]) / SteelProduced[s] <= NickelMax[s]); % The nickel content of each steel type must not exceed the maximum allowed
constraint forall(a in 1..A)(sum(s in 1..S)(SteelAlloy[s, a]) <= AvailableAlloy[a]); % The total amount of each alloy used must not exceed the available amount
constraint forall(s in 1..S)(SteelAlloy[s, 1] / SteelProduced[s] <= 0.4); % At most 40% of alloy 1 can be used in any steel type

% Objective
var int: Profit = sum(s in 1..S)(SteelPrice[s] * SteelProduced[s]) - sum(s in 1..S, a in 1..A)(AlloyPrice[a] * SteelAlloy[s, a]); % The profit is the total selling price of the steel produced minus the total purchase price of the alloys used
solve maximize Profit;