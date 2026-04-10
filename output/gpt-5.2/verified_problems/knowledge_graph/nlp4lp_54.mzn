include "float.mzn";

int: A;
set of int: ADS = 1..A;

int: Budget;                      % total budget
array[ADS] of int: Costs;         % cost per 1000 clicks for ad a
array[ADS] of int: MaxClicks;     % max clicks purchasable for ad a

array[ADS] of int: YoungClicks;   % percent of clicks that are young (0..100)
array[ADS] of int: OldClicks;     % percent of clicks that are old (0..100)
array[ADS] of int: UniqueClicks;  % percent of clicks that are unique (0..100)

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[ADS] of var 0..max(MaxClicks): Clicks;

% Budget: Costs are per 1000 clicks => sum(Costs[a] * Clicks[a] / 1000) <= Budget
constraint
  sum(a in ADS)(Costs[a] * Clicks[a]) <= 1000 * Budget;

% Total young/old click goals (percent applied to purchased clicks)
constraint
  sum(a in ADS)(YoungClicks[a] * Clicks[a]) >= 100 * GoalYoung;

constraint
  sum(a in ADS)(OldClicks[a] * Clicks[a]) >= 100 * GoalOld;

% Unique click goals by age category:
% unique_young[a] = Clicks[a] * (YoungClicks[a]/100) * (UniqueClicks[a]/100)
% Multiply through by 10000 to keep integer constraints.
constraint
  sum(a in ADS)(YoungClicks[a] * UniqueClicks[a] * Clicks[a]) >= 10000 * GoalUniqueYoung;

constraint
  sum(a in ADS)(OldClicks[a] * UniqueClicks[a] * Clicks[a]) >= 10000 * GoalUniqueOld;

% Objective: maximize total unique clicks across all ages
% total_unique[a] = Clicks[a] * (UniqueClicks[a]/100)
% Multiply objective by 100 to keep integer: maximize sum(UniqueClicks[a]*Clicks[a])
var int: TotalUniqueScaled = sum(a in ADS)(UniqueClicks[a] * Clicks[a]);

solve maximize TotalUniqueScaled;

output [
  "Clicks = ", show(Clicks), "\n",
  "TotalUniqueClicks ~= ", show(TotalUniqueScaled / 100.0), "\n",
  "BudgetUsed = ", show(sum(a in ADS)(Costs[a] * Clicks[a]) / 1000.0), "\n"
];