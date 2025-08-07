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
array[1..A] of var 0..MaxClicks[i] of int: x;

% Constraints
constraint sum(i in 1..A)(YoungClicks[i] * x[i]) >= GoalYoung * 100;
constraint sum(i in 1..A)(OldClicks[i] * x[i]) >= GoalOld * 100;
constraint sum(i in 1..A)(UniqueClicks[i] * x[i]) >= GoalUniqueYoung * 100;
constraint sum(i in 1..A)(UniqueClicks[i] * x[i]) >= GoalUniqueOld * 100;

% Objective
solve minimize sum(i in 1..A)(Costs[i] * x[i]) / 1000.0;