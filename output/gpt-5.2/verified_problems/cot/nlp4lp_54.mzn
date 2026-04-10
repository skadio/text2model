% Parameters
int: A;
set of int: ADS = 1..A;

int: Budget;

array[ADS] of int: Costs;          % cost per 1000 clicks
array[ADS] of int: MaxClicks;      % max purchasable clicks

array[ADS] of int: YoungClicks;    % % of clicks from young (0..100)
array[ADS] of int: OldClicks;      % % of clicks from old (0..100)
array[ADS] of int: UniqueClicks;   % % of clicks that are unique (0..100), same across ages

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

% Variables
array[ADS] of var int: clicks;      % number of clicks purchased per ad type

var int: total_unique_clicks;

% Constraints
constraint forall(a in ADS) (clicks[a] >= 0);
constraint forall(a in ADS) (clicks[a] <= MaxClicks[a]);

% Budget: Costs are per 1000 clicks
constraint sum(a in ADS) (Costs[a] * clicks[a]) <= 1000 * Budget;

% Audience click goals (percentages applied to purchased clicks)
constraint sum(a in ADS) (YoungClicks[a] * clicks[a]) >= 100 * GoalYoung;
constraint sum(a in ADS) (OldClicks[a] * clicks[a])   >= 100 * GoalOld;

% Unique click goals by age category (unique% assumed same across ages)
constraint sum(a in ADS) (UniqueClicks[a] * YoungClicks[a] * clicks[a]) >= 10000 * GoalUniqueYoung;
constraint sum(a in ADS) (UniqueClicks[a] * OldClicks[a] * clicks[a])   >= 10000 * GoalUniqueOld;

% Total unique clicks (across all visitors)
constraint total_unique_clicks = (sum(a in ADS) (UniqueClicks[a] * clicks[a])) div 100;

% Objective
solve maximize total_unique_clicks;