include "globals.mzn";

% Parameters
int: A;
int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;
array[1..A] of int: YoungClicks;
array[1..A] of int: OldClicks;
array[1..A] of int: Costs;
array[1..A] of int: MaxClicks;
array[1..A] of int: UniqueClicks;

% Decision Variables
array[1..A] of var 0..MaxClicks[i]: Clicks;

% Objective
var int: total_cost = sum(i in 1..A)(Clicks[i]*Costs[i]);
minimize total_cost;

% Constraints
constraint sum(i in 1..A)(Clicks[i]*YoungClicks[i]) >= GoalYoung;
constraint sum(i in 1..A)(Clicks[i]*OldClicks[i]) >= GoalOld;
constraint sum(i in 1..A)(Clicks[i]*UniqueClicks[i]) >= GoalUniqueYoung;
constraint sum(i in 1..A)(Clicks[i]*UniqueClicks[i]) >= GoalUniqueOld;

solve satisfy;