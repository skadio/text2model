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

% Variables
array[1..A] of var 0..MaxClicks[A]: Clicks;

% Constraints
constraint forall(i in 1..A)(Clicks[i] <= MaxClicks[i]);
constraint sum(i in 1..A)(YoungClicks[i]*Clicks[i]) >= GoalYoung;
constraint sum(i in 1..A)(OldClicks[i]*Clicks[i]) >= GoalOld;
constraint sum(i in 1..A)(UniqueClicks[i]*Clicks[i]) >= GoalUniqueYoung + GoalUniqueOld;

% Objective
var int: TotalCost = sum(i in 1..A)(Costs[i]*Clicks[i]);
solve minimize TotalCost;