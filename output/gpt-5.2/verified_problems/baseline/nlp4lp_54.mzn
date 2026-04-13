int: A;
set of int: ADS = 1..A;

int: Budget;

array[ADS] of int: Costs;        % cost per 1000 clicks
array[ADS] of int: MaxClicks;    % maximum clicks purchasable

array[ADS] of int: YoungClicks;  % percent (or rate per 100 clicks) of young clicks
array[ADS] of int: OldClicks;    % percent (or rate per 100 clicks) of old clicks
array[ADS] of int: UniqueClicks; % percent (or rate per 100 clicks) of unique clicks (same across ages)

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Decision: number of clicks purchased from each ad type
array[ADS] of var 0..max(MaxClicks): x;

% Total cost (Costs are per 1000 clicks)
var int: total_cost = sum(a in ADS) (Costs[a] * x[a]);
constraint total_cost <= Budget * 1000;

% Total clicks by age category (using given rates)
var int: total_young = sum(a in ADS) (YoungClicks[a] * x[a]);
var int: total_old   = sum(a in ADS) (OldClicks[a] * x[a]);

% Total unique clicks (overall), and allocated to age categories proportionally to age splits
var int: total_unique = sum(a in ADS) (UniqueClicks[a] * x[a]);

var int: unique_young = sum(a in ADS) (
  UniqueClicks[a] * x[a] * YoungClicks[a] div (YoungClicks[a] + OldClicks[a])
);

var int: unique_old = sum(a in ADS) (
  UniqueClicks[a] * x[a] * OldClicks[a] div (YoungClicks[a] + OldClicks[a])
);

% Max clicks per ad type
constraint forall(a in ADS) (x[a] <= MaxClicks[a]);

% Click goals
constraint total_young >= GoalYoung;
constraint total_old   >= GoalOld;

% Unique click goals by age category
constraint unique_young >= GoalUniqueYoung;
constraint unique_old   >= GoalUniqueOld;

% Objective: maximize number of unique clicks
solve maximize total_unique;

output [
  "ClicksPerAd = ", show(x), "\n",
  "TotalCost = ", show(total_cost), " (cost-units*clicks, constrained by Budget*1000)\n",
  "TotalYoung = ", show(total_young), "\n",
  "TotalOld = ", show(total_old), "\n",
  "TotalUnique = ", show(total_unique), "\n",
  "UniqueYoung = ", show(unique_young), "\n",
  "UniqueOld = ", show(unique_old), "\n"
];