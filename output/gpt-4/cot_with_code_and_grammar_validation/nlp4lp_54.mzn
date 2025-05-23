% Parameters
int: A;
int: Budget;
array[1..A] of int: Costs;
array[1..A] of int: MaxClicks;
array[1..A] of int: YoungClicks;
array[1..A] of int: OldClicks;
array[1..A] of int: UniqueClicks;
int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Variables
array[1..A] of var 0..MaxClicks[i] (i in 1..A): Clicks;

% Constraints
constraint sum(i in 1..A)(Clicks[i]*Costs[i]) <= Budget;
constraint sum(i in 1..A)(Clicks[i]*YoungClicks[i]) >= GoalYoung;
constraint sum(i in 1..A)(Clicks[i]*OldClicks[i]) >= GoalOld;
constraint sum(i in 1..A)(Clicks[i]*UniqueClicks[i]) >= GoalUniqueYoung + GoalUniqueOld;

% Objective
solve maximize sum(i in 1..A)(Clicks[i]*UniqueClicks[i]);