% Custom Tees advertising campaign optimization

% --------------------
% Parameters
% --------------------
int: A;
set of int: ADS = 1..A;

int: Budget; % total budget (same monetary unit as Costs)

array[ADS] of int: Costs;        % cost per 1000 clicks
array[ADS] of int: MaxClicks;    % maximum purchasable clicks

array[ADS] of int: YoungClicks;  % percentage (0..100) of clicks that are age 18-25
array[ADS] of int: OldClicks;    % percentage (0..100) of clicks that are age >25
array[ADS] of int: UniqueClicks; % percentage (0..100) of clicks that are unique

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% --------------------
% Decision variables
% --------------------
array[ADS] of var 0..max(MaxClicks): Clicks;

% Total unique clicks (integer, derived via scaling)
var 0..sum(a in ADS)(MaxClicks[a]): TotalUniqueClicks;

% --------------------
% Constraints
% --------------------
constraint forall(a in ADS) (
  Clicks[a] <= MaxClicks[a]
);

% Budget: Costs are per 1000 clicks
constraint sum(a in ADS)(Costs[a] * Clicks[a]) <= 1000 * Budget;

% Age click goals (percent scaling by 100)
constraint sum(a in ADS)(YoungClicks[a] * Clicks[a]) >= 100 * GoalYoung;
constraint sum(a in ADS)(OldClicks[a] * Clicks[a])   >= 100 * GoalOld;

% Unique click goals by age: Unique% applied to age-specific clicks (scale 100*100)
constraint sum(a in ADS)(UniqueClicks[a] * YoungClicks[a] * Clicks[a]) >= 10000 * GoalUniqueYoung;
constraint sum(a in ADS)(UniqueClicks[a] * OldClicks[a] * Clicks[a])   >= 10000 * GoalUniqueOld;

% Total unique clicks (scale by 100 to keep integer arithmetic)
constraint 100 * TotalUniqueClicks = sum(a in ADS)(UniqueClicks[a] * Clicks[a]);

% --------------------
% Objective
% --------------------
solve maximize TotalUniqueClicks;