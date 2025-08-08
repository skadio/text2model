```mzn
% This MiniZinc model chooses the number of clicks to purchase from each advertisement type 
% so as to maximize the total unique clicks, while satisfying budget and audience‐reach goals.

% ----- Data Parameters (to be provided via a .dzn file) -----
int: A;                      % Number of advertisement types
int: Budget;                 % Total advertising budget

array[1..A] of int: Costs;       % Cost per click for each ad type
array[1..A] of int: MaxClicks;   % Maximum clicks that can be purchased for each ad type
array[1..A] of int: YoungClicks; % Estimated percentage (out of 100) of clicks from visitors aged 18-25 per ad type
array[1..A] of int: OldClicks;   % Estimated percentage (out of 100) of clicks from visitors older than 25 per ad type
array[1..A] of int: UniqueClicks;% Estimated percentage (out of 100) of unique clicks among the clicks for each ad type

int: GoalYoung;         % Required number of clicks from young visitors (18-25)
int: GoalOld;           % Required number of clicks from older visitors (>25)
int: GoalUniqueYoung;   % Required number of