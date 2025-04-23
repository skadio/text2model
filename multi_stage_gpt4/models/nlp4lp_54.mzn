% Parameters
int: A; % Number of advertisement types
int: Budget; % Total budget for purchasing clicks
array[1..A] of int: Costs; % Cost of purchasing a click from advertisement type a
array[1..A] of int: MaxClicks; % Number of maximum clicks that can be purchased from advertisement type a
array[1..A] of int: YoungClicks; % Number of young audience clicks from advertisement type a
array[1..A] of int: OldClicks; % Number of old audience clicks from advertisement type a
array[1..A] of int: UniqueClicks; % Number of unique clicks from advertisement type a
int: GoalYoung; % Goal for number of clicks from young audience
int: GoalOld; % Goal for number of clicks from old audience
int: GoalUniqueYoung; % Goal for number of unique clicks from young audience
int: GoalUniqueOld; % Goal for number of unique clicks from old audience

% Variables
array[1..A] of var 0..MaxClicks[i]: PurchasedClicks; % Number of clicks purchased from each ad type

% Constraints

% The total cost of all purchased clicks should not exceed the budget
constraint sum(i in 1..A)(PurchasedClicks[i] * Costs[i]) <= Budget;

% The number of purchased clicks should not exceed the maximum allowable clicks for each ad type
constraint forall(i in 1..A)(PurchasedClicks[i] <= MaxClicks[i]);

% The total number of young audience clicks should meet the goal
constraint sum(i in 1..A)(PurchasedClicks[i] * YoungClicks[i]) >= GoalYoung;

% The total number of old audience clicks should meet the goal
constraint sum(i in 1..A)(PurchasedClicks[i] * OldClicks[i]) >= GoalOld;

% The total number of unique clicks from young audience should meet the goal
constraint sum(i in 1..A)(PurchasedClicks[i] * UniqueClicks[i] * YoungClicks[i]) >= GoalUniqueYoung;

% The total number of unique clicks from old audience should meet the goal
constraint sum(i in 1..A)(PurchasedClicks[i] * UniqueClicks[i] * OldClicks[i]) >= GoalUniqueOld;

% Objective
% Maximize the total number of unique clicks
solve maximize sum(i in 1..A)(PurchasedClicks[i] * UniqueClicks[i]);