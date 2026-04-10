include "globals.mzn";

int: A;  % Number of types of ads
int: GoalYoung;  % Total goal for clicks by young individuals
int: GoalOld;    % Total goal for clicks by old individuals
int: GoalUniqueYoung;  % Total goal for unique clicks by young individuals
int: GoalUniqueOld;    % Total goal for unique clicks by old individuals
array[1..A] of int: YoungClicks;  % Number of clicks by young individuals for each ad type
array[1..A] of int: OldClicks;    % Number of clicks by old individuals for each ad type
array[1..A] of int: Costs;        % Cost associated with each ad type
array[1..A] of int: MaxClicks;    % Maximum number of clicks possible for each ad type
array[1..A] of int: UniqueClicks;  % Number of unique clicks for each ad type

/* Variables */
array[1..A] of var 0..MaxClicks: clicks;  % Number of clicks for each ad type

/* Constraints */
constraint sum(i in 1..A)(YoungClicks[i] * clicks[i]) >= GoalYoung;  % Young clicks goal
constraint sum(i in 1..A)(OldClicks[i] * clicks[i]) >= GoalOld;      % Old clicks goal
constraint sum(i in 1..A)(UniqueClicks[i] * clicks[i]) >= GoalUniqueYoung;  % Unique young clicks goal
constraint sum(i in 1..A)(UniqueClicks[i] * clicks[i]) >= GoalUniqueOld;    % Unique old clicks goal

/* Minimize total cost */
var int: total_cost = sum(i in 1..A)(Costs[i] * clicks[i] / 1000);
solve minimize total_cost;

/* Output */
output [ "Clicks = ", show(clicks), "\nTotal Cost = ", show(total_cost), "\n" ];