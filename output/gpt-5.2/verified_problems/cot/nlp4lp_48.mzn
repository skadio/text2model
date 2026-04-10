% Parameters
int: A;
set of int: ADS = 1..A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[ADS] of int: YoungClicks;
array[ADS] of int: OldClicks;
array[ADS] of int: Costs;       % cost per 1000 clicks
array[ADS] of int: MaxClicks;
array[ADS] of int: UniqueClicks;

% Variables
array[ADS] of var 0..max(MaxClicks): Clicks;

% Constraints
constraint
  forall(a in ADS) (
    Clicks[a] <= MaxClicks[a]
  );

constraint
  sum(a in ADS) (YoungClicks[a] * Clicks[a]) >= GoalYoung * 100;

constraint
  sum(a in ADS) (OldClicks[a] * Clicks[a]) >= GoalOld * 100;

constraint
  sum(a in ADS) (UniqueClicks[a] * YoungClicks[a] * Clicks[a]) >= GoalUniqueYoung * 10000;

constraint
  sum(a in ADS) (UniqueClicks[a] * OldClicks[a] * Clicks[a]) >= GoalUniqueOld * 10000;

% Objective
solve minimize sum(a in ADS) (Costs[a] * Clicks[a]);