% --------------------------------------------------
% Custom Tees Online Advertising Campaign
% --------------------------------------------------
include "globals.mzn";

int: A;                  % number of advertisement types
int: Budget;             % total available budget

array[1..A] of int: Costs;          % cost per click (assumed in same units as Budget)
array[1..A] of int: MaxClicks;      % maximum clicks that can be bought for each ad
array[1..A] of int: YoungClicks;    % % of clicks that come from 18‑25 year olds
array[1..A] of int: OldClicks;      % % of clicks that come from >25 year olds
array[1..A] of int: UniqueClicks;   % % of purchased clicks that are unique

int: GoalYoung;           % required number of clicks from 18‑25 year olds
int: GoalOld;             % required number of clicks from >25 year olds
int: GoalUniqueYoung;     % required number of unique clicks from 18‑25 year olds
int: GoalUniqueOld;       % required number of unique clicks from >25 year olds

% --------------------------------------------------
% Decision variables
% --------------------------------------------------
array[1..A] of var int: clicks;     % number of clicks purchased for each ad type

% --------------------------------------------------
% Constraints
% --------------------------------------------------
constraint
  forall(i in 1..A)(clicks[i] >= 0 /\ clicks[i] <= MaxClicks[i]);

% Budget
constraint
  sum(i in 1..A)(clicks[i] * Costs[i]) <= Budget;

% Age‑group click goals (scaled by 100 to avoid fractions)
constraint
  sum(i in 1..A)(clicks[i] * YoungClicks[i]) >= GoalYoung * 100;
constraint
  sum(i in 1..A)(clicks[i] * OldClicks[i])   >= GoalOld   * 100;

% Unique‑click goals for each age group (scaled by 10 000)
constraint
  sum(i in 1..A)(clicks[i] * UniqueClicks[i] * YoungClicks[i])
    >= GoalUniqueYoung * 10000;
constraint
  sum(i in 1..A)(clicks[i] * UniqueClicks[i] * OldClicks[i])
    >= GoalUniqueOld   * 10000;

% --------------------------------------------------
% Objective
% --------------------------------------------------
solve maximize sum(i in 1..A)(clicks[i] * UniqueClicks[i]);

% --------------------------------------------------
% Output
% --------------------------------------------------
output [
  "Clicks per ad type : ", show(clicks), "\n",
  "Total unique clicks (scaled by 100) : ", 
  show(sum(i in 1..A)(clicks[i] * UniqueClicks[i])), "\n"
];