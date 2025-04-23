% Parameters
int: A; % Total number of different alloys
int: S; % Total number of different steel types
array[1..A] of int: AvailableAlloy; % Available amount of each alloy
array[1..A] of float: CarbonContent; % Carbon content of each alloy
array[1..A] of float: NickelContent; % Nickel content of each alloy
array[1..A] of int: AlloyPrice; % Price of each alloy
array[1..S] of int: SteelPrice; % Price of each steel type
array[1..S] of float: CarbonMin; % Minimum required carbon content for each steel type
array[1..S] of float: NickelMax; % Maximum allowed nickel content for each steel type

% Variables
array[1..A, 1..S] of var 0..AvailableAlloy[i]: AlloyInSteel; % Amount of each alloy in each steel type
array[1..S] of var 0..sum(AvailableAlloy): SteelProduced; % Amount of each steel type produced

% Constraints

% The amount of each alloy used in all types of steel should not exceed the available amount of that alloy
constraint forall(a in 1..A) (
  sum(s in 1..S) (AlloyInSteel[a, s]) <= AvailableAlloy[a]
);

% The total amount of each type of steel produced should be equal to the sum of all alloys used in that steel type
constraint forall(s in 1..S) (
  SteelProduced[s] = sum(a in 1..A) (AlloyInSteel[a, s])
);

% The carbon content in each type of steel should be at least the minimum required
constraint forall(s in 1..S) (
  sum(a in 1..A) (AlloyInSteel[a, s] * CarbonContent[a]) / SteelProduced[s] >= CarbonMin[s]
);

% The nickel content in each type of steel should not exceed the maximum allowed
constraint forall(s in 1..S) (
  sum(a in 1..A) (AlloyInSteel[a, s] * NickelContent[a]) / SteelProduced[s] <= NickelMax[s]
);

% The amount of alloy 1 in each type of steel should not exceed 40% of the total amount of that steel type
constraint forall(s in 1..S) (
  AlloyInSteel[1, s] <= 0.4 * SteelProduced[s]
);

% Objective
solve maximize sum(s in 1..S) (SteelPrice[s] * SteelProduced[s]) - sum(a in 1..A, s in 1..S) (AlloyPrice[a] * AlloyInSteel[a, s]);