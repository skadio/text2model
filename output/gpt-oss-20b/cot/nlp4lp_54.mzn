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
array[1..A] of var 0..MaxClicks[i] : x;

% Constraints
constraint
    sum(i in 1..A) x[i] * Costs[i] <= Budget;

constraint
    sum(i in 1..A) x[i] * YoungClicks[i] >= GoalYoung * 100;

constraint
    sum(i in 1..A) x[i] * OldClicks[i]   >= GoalOld * 100;

constraint
    sum(i in 1..A) x[i] * YoungClicks[i] * UniqueClicks[i] >= GoalUniqueYoung * 10000;

constraint
    sum(i in 1..A) x[i] * OldClicks[i] * UniqueClicks[i]   >= GoalUniqueOld * 10000;

% Objective
solve maximize sum(i in 1..A) x[i] * UniqueClicks[i];