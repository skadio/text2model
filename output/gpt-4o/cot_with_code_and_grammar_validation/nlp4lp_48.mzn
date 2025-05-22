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
int: MaxGlobalClicks = max(MaxClicks);
array[ADS] of var 0..MaxGlobalClicks: Clicks;

% Constraints
constraint
    forall(a in ADS) (
        Clicks[a] <= MaxClicks[a]
    );

constraint
    sum(a in ADS)(YoungClicks[a] * Clicks[a]) >= GoalYoung;

constraint
    sum(a in ADS)(OldClicks[a] * Clicks[a]) >= GoalOld;

constraint
    sum(a in ADS)(UniqueClicks[a] * Clicks[a]) >= GoalUniqueYoung;

constraint
    sum(a in ADS)(UniqueClicks[a] * Clicks[a]) >= GoalUniqueOld;

% Objective
solve minimize sum(a in ADS)(Costs[a] * Clicks[a]);