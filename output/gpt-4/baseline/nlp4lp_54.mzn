include "globals.mzn";

% Number of advertisement types
int: A;

% Total budget for purchasing clicks
int: Budget;

% Cost of purchasing a click from advertisement type a
array[1..A] of int: Costs;

% Number of maximum clicks that can be purchased from advertisement type a
array[1..A] of int: MaxClicks;

% Number of young audience clicks from advertisement type a
array[1..A] of int: YoungClicks;

% Number of old audience clicks from advertisement type a
array[1..A] of int: OldClicks;

% Number of unique clicks from advertisement type a
array[1..A] of int: UniqueClicks;

% Goal for number of clicks from young audience
int: GoalYoung;

% Goal for number of clicks from old audience
int: GoalOld;

% Goal for number of unique clicks from young audience
int: GoalUniqueYoung;

% Goal for number of unique clicks from old audience
int: GoalUniqueOld;

% Decision variable: number of clicks to purchase from each ad type
array[1..A] of var 0..MaxClicks[i]: Clicks;

% Objective: maximize the number of unique clicks
var int: total_unique_clicks = sum(i in 1..A) (Clicks[i] * UniqueClicks[i]);
maximize total_unique_clicks;

% Constraints
constraint sum(i in 1..A) (Clicks[i] * Costs[i]) <= Budget;
constraint sum(i in 1..A) (Clicks[i] * YoungClicks[i]) >= GoalYoung;
constraint sum(i in 1..A) (Clicks[i] * OldClicks[i]) >= GoalOld;
constraint sum(i in 1..A) (Clicks[i] * UniqueClicks[i]) >= GoalUniqueYoung + GoalUniqueOld;

solve satisfy;
output ["Total unique clicks: ", show(total_unique_clicks), "\n"] ++
["Clicks: ", show(Clicks), "\n"];