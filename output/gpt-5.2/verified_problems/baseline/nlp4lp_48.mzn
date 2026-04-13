int: A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[1..A] of int: YoungClicks;   % percentage (0..100) of clicks from young
array[1..A] of int: OldClicks;     % percentage (0..100) of clicks from old
array[1..A] of int: Costs;         % cost per 1000 clicks
array[1..A] of int: MaxClicks;     % maximum clicks purchasable
array[1..A] of int: UniqueClicks;  % percentage (0..100) of clicks that are unique

array[1..A] of var 0..max(MaxClicks): x;  % clicks to purchase per ad type

constraint forall(i in 1..A) (x[i] <= MaxClicks[i]);

% Meet age-specific click goals (percentages applied to purchased clicks)
constraint sum(i in 1..A) (YoungClicks[i] * x[i]) >= 100 * GoalYoung;
constraint sum(i in 1..A) (OldClicks[i] * x[i])   >= 100 * GoalOld;

% Meet age-specific unique click goals (unique percentage assumed same across ages)
constraint sum(i in 1..A) (UniqueClicks[i] * YoungClicks[i] * x[i]) >= 10000 * GoalUniqueYoung;
constraint sum(i in 1..A) (UniqueClicks[i] * OldClicks[i]   * x[i]) >= 10000 * GoalUniqueOld;

% Minimize total cost: Costs are per 1000 clicks
var int: total_cost = sum(i in 1..A) (Costs[i] * x[i]);

solve minimize total_cost;

output [
  "ClicksPerAd = ", show(x), "\n",
  "TotalCost = ", show(total_cost), "\n"
];