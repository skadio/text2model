% Parameters
int: A;                                  % Number of ad types
set of int: ADS = 1..A;                  % Index set for ad types

int: GoalYoung;                          % Total goal for clicks by young individuals (18-25)
int: GoalOld;                            % Total goal for clicks by old individuals (>25)
int: GoalUniqueYoung;                    % Total goal for unique clicks by young individuals
int: GoalUniqueOld;                      % Total goal for unique clicks by old individuals

array[ADS] of int: YoungClicks;          % Percent of clicks from young per ad type (0..100)
array[ADS] of int: OldClicks;            % Percent of clicks from old per ad type (0..100)
array[ADS] of int: Costs;                % Cost per 1000 clicks for each ad type
array[ADS] of int: MaxClicks;            % Maximum purchasable clicks for each ad type
array[ADS] of int: UniqueClicks;         % Percent of unique clicks per ad type (0..100)

% Variables
array[ADS] of var 0..max(MaxClicks): ClicksPurchased;        % Clicks purchased for each ad type

array[ADS] of var 0..max(MaxClicks): YoungClicksAchieved;    % Achieved young clicks per ad type
array[ADS] of var 0..max(MaxClicks): OldClicksAchieved;      % Achieved old clicks per ad type

array[ADS] of var 0..max(MaxClicks): UniqueYoungAchieved;    % Achieved unique young clicks per ad type
array[ADS] of var 0..max(MaxClicks): UniqueOldAchieved;      % Achieved unique old clicks per ad type

var 0..(max(Costs) * sum(MaxClicks)): TotalCost;             % Total cost (upper bound is a safe estimate)

% Constraints
% Respect per-ad maximum purchasable clicks
constraint forall(a in ADS) (
  ClicksPurchased[a] <= MaxClicks[a]
);

% Link achieved click counts to purchased clicks using age percentages
% (Percentages are integers in 0..100; equalities enforce integer rounding consistency)
constraint forall(a in ADS) (
  YoungClicksAchieved[a] * 100 = ClicksPurchased[a] * YoungClicks[a]
);
constraint forall(a in ADS) (
  OldClicksAchieved[a] * 100 = ClicksPurchased[a] * OldClicks[a]
);

% Meet overall click goals by age category
constraint sum(a in ADS)(YoungClicksAchieved[a]) >= GoalYoung;
constraint sum(a in ADS)(OldClicksAchieved[a]) >= GoalOld;

% Link unique achieved variables to purchased clicks via estimated unique percentage
% (Assumed same unique percentage applies regardless of age group)
constraint forall(a in ADS) (
  UniqueYoungAchieved[a] * 100 = ClicksPurchased[a] * UniqueClicks[a]
);
constraint forall(a in ADS) (
  UniqueOldAchieved[a] * 100 = ClicksPurchased[a] * UniqueClicks[a]
);

% Meet overall unique click goals by age category
constraint sum(a in ADS)(UniqueYoungAchieved[a]) >= GoalUniqueYoung;
constraint sum(a in ADS)(UniqueOldAchieved[a]) >= GoalUniqueOld;

% Define total cost: Costs are per 1000 clicks
constraint
  TotalCost * 1000 = sum(a in ADS)(Costs[a] * ClicksPurchased[a]);

% Objective
solve minimize TotalCost;