include "globals.mzn";

int: A;  % Number of advertisement types
array[1..A] of var 0..300: clicks;  % Clicks purchased for each ad type, max 300 as per MaxClicks

int: Budget;  % Total budget for purchasing clicks
array[1..A] of int: Costs;  % Cost of purchasing a click from advertisement type a
array[1..A] of int: MaxClicks;  % Number of maximum clicks that can be purchased from advertisement type a
array[1..A] of int: YoungClicks;  % Number of young audience clicks from advertisement type a
array[1..A] of int: OldClicks;  % Number of old audience clicks from advertisement type a
array[1..A] of int: UniqueClicks;  % Number of unique clicks from advertisement type a
int: GoalYoung;  % Goal for number of clicks from young audience
int: GoalOld;    % Goal for number of clicks from old audience
int: GoalUniqueYoung;  % Goal for number of unique clicks from young audience
int: GoalUniqueOld;    % Goal for number of unique clicks from old audience

% Constraints for achieving the goals
constraint count(clicks, YoungClicks, GoalYoung);  % Count of young audience clicks
constraint count(clicks, OldClicks, GoalOld);      % Count of old audience clicks

% Budget constraint
constraint sum(a in 1..A)(clicks[a] * Costs[a]) <= Budget;

% Unique clicks constraints
var 0..sum(UniqueClicks): totalUniqueClicks;
constraint totalUniqueClicks = sum(a in 1..A)(clicks[a] * UniqueClicks[a]);

% Solve to maximize unique clicks
solve maximize totalUniqueClicks;

% Output the results
output [ "Clicks = ", show(clicks), "\nTotal Unique Clicks = ", show(totalUniqueClicks), "\n" ];