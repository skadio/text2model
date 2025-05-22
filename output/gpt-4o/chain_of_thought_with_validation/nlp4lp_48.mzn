% Parameters
int: A;
int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;
array[1..A] of int: YoungClicks;
array[1..A] of int: OldClicks;
array[1..A] of int: Costs;
array[1..A] of int: MaxClicks;
array[1..A] of int: UniqueClicks;

% Auxiliary Parameters
int: maxMaxClicks = max(MaxClicks);

% Variables
array[1..A] of var 0..maxMaxClicks: Clicks;  % clicks to purchase for each ad type
var int: TotalCost = sum(a in 1..A)(Clicks[a] * Costs[a]);

% Constraints
constraint
  forall(a in 1..A)(
    Clicks[a] <= MaxClicks[a]
  );

constraint
  sum(a in 1..A)(Clicks[a] * YoungClicks[a]) >= GoalYoung * 100;

constraint
  sum(a in 1..A)(Clicks[a] * OldClicks[a])   >= GoalOld   * 100;

constraint
  sum(a in 1..A)(Clicks[a] * YoungClicks[a] * UniqueClicks[a])
    >= GoalUniqueYoung * 100 * 100;

constraint
  sum(a in 1..A)(Clicks[a] * OldClicks[a] * UniqueClicks[a])
    >= GoalUniqueOld   * 100 * 100;

% Objective
solve minimize TotalCost;