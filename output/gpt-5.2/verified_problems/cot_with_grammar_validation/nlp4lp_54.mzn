% Parameters
int: A;
set of int: ADS = 1..A;

int: Budget;

array[ADS] of int: Costs;         % cost per 1000 clicks
array[ADS] of int: MaxClicks;

array[ADS] of int: YoungClicks;   % percentage (or per-100) of clicks from young
array[ADS] of int: OldClicks;     % percentage (or per-100) of clicks from old
array[ADS] of int: UniqueClicks;  % percentage (or per-100) of unique clicks (same across ages)

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Variables
array[ADS] of var 0..max(MaxClicks): Clicks;

var 0..sum(a in ADS)(MaxClicks[a]): TotalUniqueClicks;

% Constraints
constraint forall(a in ADS) (
  Clicks[a] <= MaxClicks[a]
);

% Budget: Costs are per 1000 clicks -> scale by 1000 to keep integer arithmetic
constraint sum(a in ADS) (Costs[a] * Clicks[a]) <= Budget * 1000;

% Audience click goals (YoungClicks/OldClicks treated as "per 100")
constraint sum(a in ADS) (YoungClicks[a] * Clicks[a]) >= GoalYoung * 100;
constraint sum(a in ADS) (OldClicks[a] * Clicks[a])   >= GoalOld * 100;

% Unique click goals by age group:
% unique_young = unique% * young% of clicks; scale by 100*100
constraint sum(a in ADS) (UniqueClicks[a] * YoungClicks[a] * Clicks[a]) >= GoalUniqueYoung * 100 * 100;
constraint sum(a in ADS) (UniqueClicks[a] * OldClicks[a]   * Clicks[a]) >= GoalUniqueOld   * 100 * 100;

% Define objective variable: total unique clicks across all ads
% total_unique = sum(unique% * clicks), scale by 100
constraint TotalUniqueClicks * 100 = sum(a in ADS) (UniqueClicks[a] * Clicks[a]);

% Objective
solve maximize TotalUniqueClicks;