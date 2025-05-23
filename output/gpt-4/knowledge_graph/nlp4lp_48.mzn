include "globals.mzn";

% Parameters
int: A; % Number of types of ads
array[1..A] of int: YoungClicks; % Number of clicks by young individuals for each ad type
array[1..A] of int: OldClicks; % Number of clicks by old individuals for each ad type
array[1..A] of int: Costs; % Cost associated with each ad type
array[1..A] of int: MaxClicks; % Maximum number of clicks possible for each ad type
array[1..A] of int: UniqueClicks; % Number of unique clicks for each ad type
int: GoalYoung; % Total goal for clicks by young individuals
int: GoalOld; % Total goal for clicks by old individuals
int: GoalUniqueYoung; % Total goal for unique clicks by young individuals
int: GoalUniqueOld; % Total goal for unique clicks by old individuals

% Variables
array[1..A] of var 0..MaxClicks[i]: Clicks; % Number of clicks to purchase for each ad type

% Constraints
constraint sum(i in 1..A)(Clicks[i] * YoungClicks[i]) >= GoalYoung;
constraint sum(i in 1..A)(Clicks[i] * OldClicks[i]) >= GoalOld;
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i]) >= GoalUniqueYoung;
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i]) >= GoalUniqueOld;
constraint forall(i in 1..A)(Clicks[i] <= MaxClicks[i]);

% Objective
var int: TotalCost = sum(i in 1..A)(Clicks[i] * Costs[i]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Clicks: ", show(Clicks), "\n"];