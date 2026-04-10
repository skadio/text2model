% Custom Tees Online Advertising Campaign Optimization
% Minimize total cost subject to click-goal constraints for age groups and unique clicks.

int: A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[1..A] of int: YoungClicks;   % percent (0..100) of clicks from young for each ad type
array[1..A] of int: OldClicks;     % percent (0..100) of clicks from old for each ad type
array[1..A] of int: Costs;         % cost per 1000 clicks
array[1..A] of int: MaxClicks;     % max clicks purchasable for each ad type
array[1..A] of int: UniqueClicks;  % percent (0..100) of unique clicks for each ad type

% Decision variables: number of clicks purchased for each ad type
array[1..A] of var 0..max(MaxClicks): clicks;

% Respect per-ad maximums
constraint forall(a in 1..A) (clicks[a] <= MaxClicks[a]);

% Age-group click goals (use integer arithmetic; scale by 100)
constraint sum(a in 1..A) (YoungClicks[a] * clicks[a]) >= 100 * GoalYoung;
constraint sum(a in 1..A) (OldClicks[a]   * clicks[a]) >= 100 * GoalOld;

% Unique click goals by age category:
% unique_young = young% * unique% * clicks, similarly for old.
% Scale by 100*100 = 10000 to keep integers.
constraint sum(a in 1..A) (YoungClicks[a] * UniqueClicks[a] * clicks[a]) >= 10000 * GoalUniqueYoung;
constraint sum(a in 1..A) (OldClicks[a]   * UniqueClicks[a] * clicks[a]) >= 10000 * GoalUniqueOld;

% Objective: minimize total cost
% Costs are per 1000 clicks, so minimize sum(Costs[a] * clicks[a]) / 1000.
% Avoid division by minimizing the numerator.
var int: total_cost_x1000 = sum(a in 1..A) (Costs[a] * clicks[a]);

solve minimize total_cost_x1000;

output [
  "Clicks per ad type = ", show(clicks), "\n",
  "Total cost (per 1000 basis, numerator) = ", show(total_cost_x1000), "\n",
  "Total cost (approx) = ", show(total_cost_x1000 / 1000.0), "\n"
];