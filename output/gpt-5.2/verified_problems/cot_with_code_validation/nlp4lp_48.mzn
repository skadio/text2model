% Custom Tees advertising campaign - cost minimization

% Parameters
int: A;
set of int: ADS = 1..A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[ADS] of int: YoungClicks;    % percent (or rate) of clicks from 18-25 per ad type
array[ADS] of int: OldClicks;      % percent (or rate) of clicks from 25+ per ad type
array[ADS] of int: Costs;          % cost per 1000 clicks (scaled consistently with Clicks units)
array[ADS] of int: MaxClicks;      % maximum clicks purchasable for each ad type
array[ADS] of int: UniqueClicks;   % percent (or rate) of unique visitors per ad type

% Decision variables
array[ADS] of var 0..max(MaxClicks): Clicks;  % number of clicks to purchase for each ad type

% If Costs are "per 1000 clicks" and Clicks are individual clicks,
% scale cost by 1/1000 to keep integers: multiply objective by 1000.
var int: TotalCost1000 = sum(a in ADS)(Costs[a] * Clicks[a]);

% Constraints (treating YoungClicks/OldClicks/UniqueClicks as percentages out of 100)
constraint sum(a in ADS)(YoungClicks[a] * Clicks[a]) >= 100 * GoalYoung;
constraint sum(a in ADS)(OldClicks[a] * Clicks[a]) >= 100 * GoalOld;

constraint sum(a in ADS)(UniqueClicks[a] * YoungClicks[a] * Clicks[a]) >= 100 * 100 * GoalUniqueYoung;
constraint sum(a in ADS)(UniqueClicks[a] * OldClicks[a] * Clicks[a]) >= 100 * 100 * GoalUniqueOld;

solve minimize TotalCost1000;

output [
  "Clicks = ", show(Clicks), "\n",
  "TotalCost1000 = ", show(TotalCost1000), "\n"
];