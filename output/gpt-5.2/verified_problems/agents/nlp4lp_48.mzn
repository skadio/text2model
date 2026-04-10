% Parameters
int: A;                                   % Number of ad types
set of int: ADS = 1..A;                   % Index set for ad types

int: GoalYoung;                           % Total click goal from visitors aged 18-25
int: GoalOld;                             % Total click goal from visitors older than 25
int: GoalUniqueYoung;                     % Total unique click goal from visitors aged 18-25
int: GoalUniqueOld;                       % Total unique click goal from visitors older than 25

array[ADS] of int: YoungClicks;           % Percent/weight of clicks from young visitors per ad type (0..100)
array[ADS] of int: OldClicks;             % Percent/weight of clicks from old visitors per ad type (0..100)
array[ADS] of int: Costs;                 % Cost per 1000 clicks for each ad type
array[ADS] of int: MaxClicks;             % Maximum clicks purchasable for each ad type
array[ADS] of int: UniqueClicks;          % Percent/weight of unique clicks per ad type (0..100, applies to all ages)

% Variables
array[ADS] of var 0..max(MaxClicks): ClicksPurchased;  % Clicks to purchase per ad type

var 0..sum(MaxClicks): TotalYoungClicks;               % Derived total young clicks
var 0..sum(MaxClicks): TotalOldClicks;                 % Derived total old clicks
var 0..sum(MaxClicks): TotalUniqueYoungClicks;         % Derived total unique young clicks
var 0..sum(MaxClicks): TotalUniqueOldClicks;           % Derived total unique old clicks

var 0..sum(Costs[i] * MaxClicks[i] | i in ADS): TotalCost; % Upper bound in cost-units (safe over-approx)

% Constraints
% --- Respect maximum purchasable clicks per ad type (also ensured by domain, kept for clarity) ---
constraint forall(i in ADS) (
  ClicksPurchased[i] <= MaxClicks[i]
);

% --- Compute total clicks by age group (using percent/weights) ---
constraint
  TotalYoungClicks =
    sum(i in ADS) ( (ClicksPurchased[i] * YoungClicks[i]) div 100 );

constraint
  TotalOldClicks =
    sum(i in ADS) ( (ClicksPurchased[i] * OldClicks[i]) div 100 );

% --- Compute unique clicks by age group (unique % applies equally across age categories) ---
constraint
  TotalUniqueYoungClicks =
    sum(i in ADS) ( (ClicksPurchased[i] * YoungClicks[i] * UniqueClicks[i]) div 10000 );

constraint
  TotalUniqueOldClicks =
    sum(i in ADS) ( (ClicksPurchased[i] * OldClicks[i] * UniqueClicks[i]) div 10000 );

% --- Enforce click goals ---
constraint TotalYoungClicks >= GoalYoung;
constraint TotalOldClicks   >= GoalOld;

% --- Enforce unique click goals ---
constraint TotalUniqueYoungClicks >= GoalUniqueYoung;
constraint TotalUniqueOldClicks   >= GoalUniqueOld;

% --- Compute total cost (Costs are per 1000 clicks) ---
constraint
  TotalCost =
    sum(i in ADS) ( (ClicksPurchased[i] * Costs[i]) div 1000 );

% Objective
solve minimize TotalCost;