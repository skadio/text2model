% Parameters
int: A;
set of int: ADS = 1..A;

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

array[ADS] of int: YoungClicks;
array[ADS] of int: OldClicks;
array[ADS] of int: Costs;
array[ADS] of int: MaxClicks;
array[ADS] of int: UniqueClicks;

% Variables
array[ADS] of var 0..max(MaxClicks): x;

% Constraints
constraint forall(a in ADS) (
  x[a] <= MaxClicks[a]
);

constraint sum(a in ADS) (YoungClicks[a] * x[a]) >= GoalYoung;

constraint sum(a in ADS) (OldClicks[a] * x[a]) >= GoalOld;

constraint sum(a in ADS) (UniqueClicks[a] * YoungClicks[a] * x[a]) >= GoalUniqueYoung;

constraint sum(a in ADS) (UniqueClicks[a] * OldClicks[a] * x[a]) >= GoalUniqueOld;

% Objective
solve minimize sum(a in ADS) (Costs[a] * x[a]);