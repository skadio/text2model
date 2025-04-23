% Parameters
int: A; % Number of types of ads
int: GoalYoung; % Total goal for clicks by young individuals
int: GoalOld; % Total goal for clicks by old individuals
int: GoalUniqueYoung; % Total goal for unique clicks by young individuals
int: GoalUniqueOld; % Total goal for unique clicks by old individuals
array[1..A] of int: YoungClicks; % Number of clicks by young individuals for each ad type
array[1..A] of int: OldClicks; % Number of clicks by old individuals for each ad type
array[1..A] of int: Costs; % Cost associated with each ad type
array[1..A] of int: MaxClicks; % Maximum number of clicks possible for each ad type
array[1..A] of int: UniqueClicks; % Number of unique clicks for each ad type

% Variables
array[1..A] of var 0..MaxClicks[i]: Clicks; % Number of clicks to purchase for each ad type

% Constraints

% The total number of clicks from young individuals should meet the goal
constraint sum(i in 1..A)(Clicks[i] * YoungClicks[i]) >= GoalYoung;

% The total number of clicks from old individuals should meet the goal
constraint sum(i in 1..A)(Clicks[i] * OldClicks[i]) >= GoalOld;

% The total number of unique clicks from young individuals should meet the goal
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i] * YoungClicks[i]) >= GoalUniqueYoung;

% The total number of unique clicks from old individuals should meet the goal
constraint sum(i in 1..A)(Clicks[i] * UniqueClicks[i] * OldClicks[i]) >= GoalUniqueOld;

% The number of clicks for each ad type should not exceed the maximum allowable number of clicks
constraint forall(i in 1..A)(Clicks[i] <= MaxClicks[i]);

% The total cost should not exceed the budget
% constraint sum(i in 1..A)(Clicks[i] * Costs[i]) <= Budget; % Uncomment this line if a budget constraint is needed

% Objective
solve minimize sum(i in 1..A)(Clicks[i] * Costs[i]);