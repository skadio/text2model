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
array[1..A] of var 0..MaxClicks[i]: Clicks; % Number of clicks to be purchased from each advertisement type

% Constraints

% The total cost of all clicks should not exceed the budget
constraint sum(i in 1..A)(Clicks[i] * Costs[i]) <= Budget;

% The number of clicks from each ad type should not exceed the maximum allowable number of clicks
constraint forall(i in 1..A)(Clicks[i] <= MaxClicks[i]);

% The total number of clicks from young audience should meet the goal
constraint sum(i in 1..A)(Clicks[i] * YoungClicks[i]) >= GoalYoung;

% The total number of clicks from old audience should meet the goal
constraint sum(i in 1..A)(Clicks[i] * OldClicks[i]) >= GoalOld;

% The total number of unique clicks from young audience should meet the goal
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i]) >= GoalUniqueYoung;

% The total number of unique clicks from old audience should meet the goal
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i]) >= GoalUniqueOld;

% Objective
solve maximize sum(i in 1..A)(Clicks[i] * UniqueClicks[i]);