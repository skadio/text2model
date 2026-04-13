% Parameters
int: A;
set of int: ADS = 1..A;

int: Budget;

array[ADS] of int: Costs;         % cost per 1000 clicks
array[ADS] of int: MaxClicks;     % max purchasable clicks

array[ADS] of int: YoungClicks;   % % of clicks from young (0..100)
array[ADS] of int: OldClicks;     % % of clicks from old (0..100)
array[ADS] of int: UniqueClicks;  % % of unique clicks (0..100), same across ages

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Variables
array[ADS] of var 0..0: x_init; % placeholder to ensure declaration order (not used)
array[ADS] of var 0..max(MaxClicks): Clicks;

var 0..sum(MaxClicks): TotalUniqueClicks;

% Constraints
constraint forall(a in ADS) (
  Clicks[a] <= MaxClicks[a]
);

% Budget: Costs are per 1000 clicks; avoid floats by multiplying by 1000
constraint sum(a in ADS) (Costs[a] * Clicks[a]) <= Budget * 1000;

% Audience click goals (percentages)
constraint sum(a in ADS) (YoungClicks[a] * Clicks[a]) >= GoalYoung * 100;
constraint sum(a in ADS) (OldClicks[a] * Clicks[a]) >= GoalOld * 100;

% Unique click goals by age (unique% assumed same across age categories)
constraint sum(a in ADS) (UniqueClicks[a] * YoungClicks[a] * Clicks[a]) >= GoalUniqueYoung * 10000;
constraint sum(a in ADS) (UniqueClicks[a] * OldClicks[a] * Clicks[a]) >= GoalUniqueOld * 10000;

% Total unique clicks (objective quantity)
constraint TotalUniqueClicks * 100 = sum(a in ADS) (UniqueClicks[a] * Clicks[a]);

% Objective
solve maximize TotalUniqueClicks;