% Parameters
int: A;                                   % Number of advertisement types
set of int: ADS = 1..A;                   % Index set for advertisement types

int: Budget;                              % Total budget available

array[ADS] of int: Costs;                 % Cost per 1000 clicks for ad type a
array[ADS] of int: MaxClicks;             % Maximum clicks purchasable for ad type a

array[ADS] of int: YoungClicks;           % Estimated % of clicks from age 18-25 for ad type a (0..100)
array[ADS] of int: OldClicks;             % Estimated % of clicks from age >25 for ad type a (0..100)
array[ADS] of int: UniqueClicks;          % Estimated % of unique clicks for ad type a (0..100), same across ages

int: GoalYoung;                           % Minimum required young-audience clicks
int: GoalOld;                             % Minimum required old-audience clicks
int: GoalUniqueYoung;                     % Minimum required unique clicks from young audience
int: GoalUniqueOld;                       % Minimum required unique clicks from old audience


% Variables
array[ADS] of var 0..max(MaxClicks): clicks;   % Clicks purchased from each ad type

var 0..Budget: total_cost;                     % Total spend (Costs are per 1000 clicks)
var 0..sum(a in ADS)(MaxClicks[a]): total_young_clicks;
var 0..sum(a in ADS)(MaxClicks[a]): total_old_clicks;
var 0..sum(a in ADS)(MaxClicks[a]): total_unique_young;
var 0..sum(a in ADS)(MaxClicks[a]): total_unique_old;
var 0..2 * sum(a in ADS)(MaxClicks[a]): total_unique_clicks;


% Constraints
% --- Click decision variable bounds (respect maximum purchasable clicks) ---
constraint
  forall(a in ADS) (
    clicks[a] <= MaxClicks[a]
  );

% --- Budget / total cost computation (Costs are per 1000 clicks) ---
constraint
  total_cost = sum(a in ADS) ( (Costs[a] * clicks[a]) div 1000 );

constraint
  total_cost <= Budget;

% --- Total clicks by age group (using estimated percentages) ---
constraint
  total_young_clicks = sum(a in ADS) ( (YoungClicks[a] * clicks[a]) div 100 );

constraint
  total_old_clicks = sum(a in ADS) ( (OldClicks[a] * clicks[a]) div 100 );

% --- Minimum goals for age group clicks ---
constraint
  total_young_clicks >= GoalYoung;

constraint
  total_old_clicks >= GoalOld;

% --- Unique clicks by age group (unique% applied to age-specific clicks) ---
constraint
  total_unique_young = sum(a in ADS) (
    (UniqueClicks[a] * ((YoungClicks[a] * clicks[a]) div 100)) div 100
  );

constraint
  total_unique_old = sum(a in ADS) (
    (UniqueClicks[a] * ((OldClicks[a] * clicks[a]) div 100)) div 100
  );

% --- Minimum goals for unique clicks by age group ---
constraint
  total_unique_young >= GoalUniqueYoung;

constraint
  total_unique_old >= GoalUniqueOld;

% --- Total unique clicks across all ages (derived) ---
constraint
  total_unique_clicks = total_unique_young + total_unique_old;


% Objective
solve maximize total_unique_clicks;