include "globals.mzn";

/*************
 * Input data
 *************/
int: A;                           % number of ad types
int: Budget;                      % total budget

array[1..A] of int: Costs;        % cost per 1000 clicks for ad a
array[1..A] of int: MaxClicks;    % maximum purchasable clicks for ad a

array[1..A] of int: YoungClicks;  % % young clicks (0..100) for ad a
array[1..A] of int: OldClicks;    % % old clicks (0..100) for ad a
array[1..A] of int: UniqueClicks; % % unique visitors/clicks (0..100) for ad a

int: GoalYoung;
int: GoalOld;
int: GoalUniqueYoung;
int: GoalUniqueOld;

/****************
 * Decision vars
 ****************/
array[1..A] of var 0..max(MaxClicks): clicks;  % clicks to buy from each ad type

/****************
 * Helper vars
 ****************/
var 0..sum(MaxClicks): totalClicks = sum(a in 1..A)(clicks[a]);

% Work in "click-units" (scaled by 100) to avoid fractions:
% e.g., young_units = sum(clicks[a] * YoungClicks[a]) represents 100*#young_clicks
var 0..100*sum(MaxClicks): young_units  = sum(a in 1..A)(clicks[a] * YoungClicks[a]);
var 0..100*sum(MaxClicks): old_units    = sum(a in 1..A)(clicks[a] * OldClicks[a]);

% unique click-units similarly
var 0..100*sum(MaxClicks): unique_units = sum(a in 1..A)(clicks[a] * UniqueClicks[a]);

% Unique young/old units assume independence between age mix and uniqueness:
% unique_young_units = sum(clicks[a] * UniqueClicks[a] * YoungClicks[a])  (scaled by 100*100)
% So it's in 10,000*clicks.
var 0..100*100*sum(MaxClicks): unique_young_units =
  sum(a in 1..A)(clicks[a] * UniqueClicks[a] * YoungClicks[a]);
var 0..100*100*sum(MaxClicks): unique_old_units =
  sum(a in 1..A)(clicks[a] * UniqueClicks[a] * OldClicks[a]);

/***************
 * Constraints
 ***************/
% Bounds already ensure clicks[a] <= MaxClicks[a]
constraint forall(a in 1..A)(clicks[a] <= MaxClicks[a]);

% Budget: Costs are per 1000 clicks.
% Use integer arithmetic: sum(Costs[a] * clicks[a]) <= Budget*1000
constraint sum(a in 1..A)(Costs[a] * clicks[a]) <= Budget * 1000;

% Age click goals (YoungClicks/OldClicks are percentages 0..100):
% young_units = 100 * (#young clicks). Enforce >= 100*GoalYoung
constraint young_units >= 100 * GoalYoung;
constraint old_units   >= 100 * GoalOld;

% Unique click goals by age:
% unique_young_units is 100*100*(#unique young clicks) so compare to 10000*goal
constraint unique_young_units >= 100 * 100 * GoalUniqueYoung;
constraint unique_old_units   >= 100 * 100 * GoalUniqueOld;

/************
 * Objective
 ************/
% Maximize total unique clicks (unique_units = 100 * unique_clicks)
solve maximize unique_units;

/**********
 * Output
 **********/
output [
  "Clicks per ad type = ", show(clicks), "\n",
  "Total clicks = ", show(totalClicks), "\n",
  "Total unique clicks (approx) = ", show(unique_units div 100), "\n",
  "Young clicks (approx) = ", show(young_units div 100), "\n",
  "Old clicks (approx) = ", show(old_units div 100), "\n",
  "Unique young clicks (approx) = ", show(unique_young_units div (100*100)), "\n",
  "Unique old clicks (approx) = ", show(unique_old_units div (100*100)), "\n",
  "Total spend = ", show(sum(a in 1..A)(Costs[a] * clicks[a]) div 1000), " (in budget units)\n"
];