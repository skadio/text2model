% Parameters
int: A;
set of int: ADS = 1..A;

int: Budget;

array[ADS] of int: Costs;
array[ADS] of int: MaxClicks;
array[ADS] of int: YoungClicks;
array[ADS] of int: OldClicks;
array[ADS] of int: UniqueClicks;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Derived constant
int: MaxClicksUpper = max(MaxClicks);

% Variables
array[ADS] of var 0..MaxClicksUpper: Clicks;

% Constraints
constraint
  forall(a in ADS)(Clicks[a] <= MaxClicks[a]);

constraint
  sum(a in ADS)(Clicks[a] * Costs[a]) <= Budget;

constraint
  sum(a in ADS)(Clicks[a] * YoungClicks[a]) >= GoalYoung * 100;

constraint
  sum(a in ADS)(Clicks[a] * OldClicks[a]) >= GoalOld * 100;

constraint
  sum(a in ADS)(Clicks[a] * YoungClicks[a] * UniqueClicks[a]) >= GoalUniqueYoung * 10000;

constraint
  sum(a in ADS)(Clicks[a] * OldClicks[a] * UniqueClicks[a]) >= GoalUniqueOld * 10000;

% Objective
var int: TotalUnique = sum(a in ADS)(Clicks[a] * UniqueClicks[a]);

solve maximize TotalUnique;