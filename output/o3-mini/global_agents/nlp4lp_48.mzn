include "globals.mzn";

% Parameters from data
int: A;                              % Number of ad types
int: GoalYoung;                      % Total required clicks from young (18-25)
int: GoalOld;                        % Total required clicks from old (>25)
int: GoalUniqueYoung;                % Unique clicks goal for young
int: GoalUniqueOld;                  % Unique clicks goal for old

array[1..A] of int: YoungClicks;     % Percentage of clicks from young (sums with OldClicks=100)
array[1..A] of int: OldClicks;       % Percentage of clicks from old (sums with YoungClicks=100)
array[1..A] of int: Costs;           % Cost per 1000 clicks for each ad type
array[1..A] of int: MaxClicks;       % Maximum allowable clicks for each ad type
array[1..A] of int: UniqueClicks;    % Percentage of unique clicks (applies to both age groups)

% Decision variables: number of clicks to purchase from each ad type
array[1..A] of var 0..MaxClicks[i]: clicks;

% Constraint: do not exceed maximum allowed clicks for each ad type
constraint
    forall(i in 1..A)( clicks[i] <= MaxClicks[i] );

% Constraints for total clicks by age group
% For an ad i, expected clicks from young = (YoungClicks[i]/100)*clicks[i]
constraint sum(i in 1..A)( clicks[i] * YoungClicks[i] ) >= 100 * GoalYoung;
constraint sum(i in 1..A)( clicks[i] * OldClicks[i]   ) >= 100 * GoalOld;

% Constraints for unique clicks by age group.
% For ad i, unique young clicks = clicks[i]*(YoungClicks[i]/100)*(UniqueClicks[i]/100)
% and unique old clicks = clicks[i]*(OldClicks[i]/100)*(UniqueClicks[i]/100).
% Multiply both sides by 10,000 to avoid fractions.
constraint sum(i in 1..A)( clicks[i] * YoungClicks[i] * UniqueClicks[i] ) >= 10000 * GoalUniqueYoung;
constraint sum(i in 1..A)( clicks[i] * OldClicks[i]   * UniqueClicks[i] ) >= 10000 * GoalUniqueOld;

% Objective: minimize the total cost.
% Cost for ad i = Costs[i]*(clicks[i]/1000). We use float for proper division.
var float: totalCost = sum(i in 1..A)( (Costs[i] / 1000.0) * clicks[i] );

solve minimize totalCost;

output [
  "Clicks purchased per ad type: ", show(clicks), "\n",
  "Total Cost: ", show(totalCost), "\n"
];