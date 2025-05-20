include "globals.mzn";

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
array[1..A] of var 0..MaxClicks[i]: Clicks; % Number of clicks purchased from advertisement type a

% Constraints
constraint sum(i in 1..A)(Clicks[i]*Costs[i]) <= Budget;
constraint sum(i in 1..A)(Clicks[i]*YoungClicks[i]) >= GoalYoung;
constraint sum(i in 1..A)(Clicks[i]*OldClicks[i]) >= GoalOld;
constraint sum(i in 1..A)(Clicks[i]*UniqueClicks[i]) >= GoalUniqueYoung + GoalUniqueOld;

% Objective
var int: total_unique_clicks = sum(i in 1..A)(Clicks[i]*UniqueClicks[i]);
solve maximize total_unique_clicks;

% Output
output ["Total unique clicks: ", show(total_unique_clicks), "\n"] ++
["Clicks: "] ++ [show(Clicks[i]) | i in 1..A];