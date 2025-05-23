int: A;
set of int: ADS = 1..A;

array[ADS] of int: Costs;         % cost per click (or per unit)
array[ADS] of int: MaxClicks;     % maximum purchasable clicks
array[ADS] of int: YoungClicks;   % % of young clicks (0–100)
array[ADS] of int: OldClicks;     % % of old clicks (0–100)
array[ADS] of int: UniqueClicks;  % % of unique clicks (0–100)

int: Budget;                      % total advertising budget

int: GoalYoung;                   % required young clicks
int: GoalOld;                     % required old clicks
int: GoalUniqueYoung;             % required unique young clicks
int: GoalUniqueOld;               % required unique old clicks

int: MaxClickBound = max(MaxClicks);

array[ADS] of var 0..MaxClickBound: clicks;    % clicks to purchase from each ad

constraint
  forall(a in ADS)(clicks[a] <= MaxClicks[a]);

constraint
  sum(a in ADS)(Costs[a] * clicks[a]) <= Budget;

constraint
  sum(a in ADS)(YoungClicks[a] * clicks[a]) >= 100 * GoalYoung;

constraint
  sum(a in ADS)(OldClicks[a] * clicks[a]) >= 100 * GoalOld;

constraint
  sum(a in ADS)(UniqueClicks[a] * YoungClicks[a] * clicks[a]) >= 10000 * GoalUniqueYoung;

constraint
  sum(a in ADS)(UniqueClicks[a] * OldClicks[a] * clicks[a]) >= 10000 * GoalUniqueOld;

solve maximize
  sum(a in ADS)(UniqueClicks[a] * clicks[a]);