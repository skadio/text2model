% Parameters (with values embedded)
int: profitA = 30;
int: profitB = 10;

int: maxHours = 40;
int: hoursPerKgA = 6;
int: hoursPerKgB = 3;

int: demandMultiplier = 3;         % B >= 3 * A

int: storageRatioAtoB = 4;         % (given but not needed beyond the explicit cap on A)
int: maxStoreA = 4;                % A <= 4 kg per week

% Variables
var 0..maxStoreA: A;               % kg of product A produced/sold per week
var 0..13: B;                      % kg of product B produced/sold per week (upper bound from time: floor(40/3)=13)

% Constraints
constraint hoursPerKgA * A + hoursPerKgB * B <= maxHours;
constraint B >= demandMultiplier * A;

% Storage constraint (explicit cap on A)
constraint A <= maxStoreA;

% Objective
solve maximize profitA * A + profitB * B;