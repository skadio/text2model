include "globals.mzn";

/* Problem data – provided from a .dzn file */
int: A;
array[1..A] of int: YoungClicks;       % expected young clicks per 1000 clicks
array[1..A] of int: OldClicks;         % expected old   clicks per 1000 clicks
array[1..A] of int: Costs;             % cost per 1000 clicks
array[1..A] of int: MaxBlocks;         % maximum 1000‑click blocks that can be bought
array[1..A] of int: UniqueClicks;      % unique clicks per 1000 clicks (same for both age groups)

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

/* Decision variables – number of 1000‑click blocks to buy for each ad type */
int: maxBlock = max(MaxBlocks);
array[1..A] of var 0..maxBlock: units;

/* Respect the per‑ad maximum limits */
constraint forall(i in 1..A)( units[i] <= MaxBlocks[i] );

/* Satisfaction constraints */
constraint sum(i in 1..A)( units[i] * YoungClicks[i] ) >= GoalYoung;
constraint sum(i in 1..A)( units[i] * OldClicks[i]   ) >= GoalOld;
constraint sum(i in 1..A)( units[i] * UniqueClicks[i] ) >= GoalUniqueYoung;
constraint sum(i in 1..A)( units[i] * UniqueClicks[i] ) >= GoalUniqueOld;

/* Objective – minimise total cost */
solve minimize sum(i in 1..A)( units[i] * Costs[i] );

/* Output results */
output [
  "Units (1000‑click blocks) per ad type: ", show(units), "\n",
  "Total young clicks   : ", show(sum(i in 1..A)(units[i] * YoungClicks[i])), "\n",
  "Total old   clicks   : ", show(sum(i in 1..A)(units[i] * OldClicks[i])),   "\n",
  "Total unique clicks  : ", show(sum(i in 1..A)(units[i] * UniqueClicks[i])), "\n",
  "Total cost (USD)     : ", show(sum(i in 1..A)(units[i] * Costs[i])), "\n"
];