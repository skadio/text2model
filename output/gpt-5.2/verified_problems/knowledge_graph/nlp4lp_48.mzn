int: A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[1..A] of int: YoungClicks;
array[1..A] of int: OldClicks;
array[1..A] of int: Costs;        % cost per 1000 clicks
array[1..A] of int: MaxClicks;
array[1..A] of int: UniqueClicks; % unique clicks per 1000 clicks (assumed same for both age groups)

array[1..A] of var 0..max(MaxClicks): Clicks;

constraint
  forall(i in 1..A)(Clicks[i] <= MaxClicks[i]);

% Age-category click goals
constraint
  sum(i in 1..A)(YoungClicks[i] * Clicks[i]) >= GoalYoung * 1000;

constraint
  sum(i in 1..A)(OldClicks[i] * Clicks[i]) >= GoalOld * 1000;

% Unique-click goals per age category, using same unique rate for both
constraint
  sum(i in 1..A)(UniqueClicks[i] * YoungClicks[i] * Clicks[i]) >= GoalUniqueYoung * 1000 * 1000;

constraint
  sum(i in 1..A)(UniqueClicks[i] * OldClicks[i] * Clicks[i]) >= GoalUniqueOld * 1000 * 1000;

var int: TotalCost = sum(i in 1..A)(Costs[i] * Clicks[i]);

solve minimize TotalCost;

output [
  "Clicks = ", show(Clicks), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];