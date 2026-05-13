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

array[1..A] of var 0..MaxClicks[i] : x;

var int: total_young = sum(i in 1..A) x[i] * YoungClicks[i];
var int: total_old   = sum(i in 1..A) x[i] * OldClicks[i];
var int: total_unique = sum(i in 1..A) x[i] * UniqueClicks[i];
var int: total_unique_young = sum(i in 1..A) x[i] * YoungClicks[i] * UniqueClicks[i];
var int: total_unique_old   = sum(i in 1..A) x[i] * OldClicks[i] * UniqueClicks[i];

constraint sum(i in 1..A) x[i] * Costs[i] <= Budget * 1000;
constraint total_young >= GoalYoung * 100;
constraint total_old   >= GoalOld   * 100;
constraint total_unique_young >= GoalUniqueYoung * 100;
constraint total_unique_old   >= GoalUniqueOld   * 100;

solve maximize total_unique;

output [
  "x: ", show(x), "\n",
  "Total Young Clicks: ", show(total_young div 100), "\n",
  "Total Old Clicks: ", show(total_old div 100), "\n",
  "Total Unique Clicks: ", show(total_unique div 100), "\n",
  "Total Unique Young Clicks: ", show(total_unique_young div 100), "\n",
  "Total Unique Old Clicks: ", show(total_unique_old div 100), "\n"
];