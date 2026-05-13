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

array[1..A] of var 0..max(MaxClicks) of int: x;

constraint
    sum(i in 1..A)(x[i] * YoungClicks[i]) >= GoalYoung * 100;

constraint
    sum(i in 1..A)(x[i] * OldClicks[i]) >= GoalOld * 100;

constraint
    sum(i in 1..A)(x[i] * UniqueClicks[i] * YoungClicks[i]) >= GoalUniqueYoung * 10000;

constraint
    sum(i in 1..A)(x[i] * UniqueClicks[i] * OldClicks[i]) >= GoalUniqueOld * 10000;

constraint
    forall(i in 1..A)(x[i] <= MaxClicks[i]);

solve minimize sum(i in 1..A)(x[i] * Costs[i]);

output [
    "x = ", show(x), "\n",
    "TotalCost = ", show(sum(i in 1..A)(x[i] * Costs[i]) / 1000.0), "\n"
];