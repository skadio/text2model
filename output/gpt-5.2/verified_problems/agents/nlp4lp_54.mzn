% Parameters
int: A;                               % Number of advertisement types
set of int: ADS = 1..A;               % Index set for ad types

int: Budget;                          % Total available budget

array[ADS] of int: Costs;             % Cost per 1000 clicks for ad type a
array[ADS] of int: MaxClicks;         % Maximum clicks purchasable for ad type a

array[ADS] of int: YoungClicks;       % Estimated % of clicks from age 18-25 for ad type a
array[ADS] of int: OldClicks;         % Estimated % of clicks from age >25 for ad type a
array[ADS] of int: UniqueClicks;      % Estimated % of unique clicks for ad type a (assumed same across ages)

int: GoalYoung;                       % Goal for total young-audience clicks
int: GoalOld;                         % Goal for total old-audience clicks
int: GoalUniqueYoung;                 % Goal for unique young-audience clicks
int: GoalUniqueOld;                   % Goal for unique old-audience clicks


% Variables
array[ADS] of var 0..max(MaxClicks): clicks;  % Number of clicks to purchase for each ad type

var 0..sum(MaxClicks): totalClicks;           % Total clicks purchased across all ads
var 0..sum(MaxClicks): youngClicksTotal;      % Total expected young-audience clicks
var 0..sum(MaxClicks): oldClicksTotal;        % Total expected old-audience clicks
var 0..sum(MaxClicks): uniqueClicksTotal;     % Total expected unique clicks

var 0..sum(MaxClicks): uniqueYoungTotal;      % Total expected unique clicks from young audience
var 0..sum(MaxClicks): uniqueOldTotal;        % Total expected unique clicks from old audience


% Constraints

% --- Purchase limits per ad type (already implied by variable domains, kept for clarity) ---
constraint
  forall(a in ADS) (
    clicks[a] <= MaxClicks[a]
  );

% --- Budget constraint (Costs are per 1000 clicks; avoid floats by cross-multiplying) ---
constraint
  sum(a in ADS) (Costs[a] * clicks[a]) <= Budget * 1000;

% --- Define total clicks purchased ---
constraint
  totalClicks = sum(a in ADS) (clicks[a]);

% --- Define expected age-segment click totals (percentages; keep integer by div 100) ---
constraint
  youngClicksTotal = sum(a in ADS) ((clicks[a] * YoungClicks[a]) div 100);

constraint
  oldClicksTotal = sum(a in ADS) ((clicks[a] * OldClicks[a]) div 100);

% --- Define expected unique clicks total (unique percentage applies to all clicks) ---
constraint
  uniqueClicksTotal = sum(a in ADS) ((clicks[a] * UniqueClicks[a]) div 100);

% --- Define expected unique clicks by age segment (unique% applied within each segment) ---
constraint
  uniqueYoungTotal =
    sum(a in ADS) ( (((clicks[a] * YoungClicks[a]) div 100) * UniqueClicks[a]) div 100 );

constraint
  uniqueOldTotal =
    sum(a in ADS) ( (((clicks[a] * OldClicks[a]) div 100) * UniqueClicks[a]) div 100 );

% --- Goal satisfaction constraints ---
constraint youngClicksTotal >= GoalYoung;
constraint oldClicksTotal >= GoalOld;
constraint uniqueYoungTotal >= GoalUniqueYoung;
constraint uniqueOldTotal >= GoalUniqueOld;


% Objective
solve maximize uniqueClicksTotal;