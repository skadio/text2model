% Parameters
int: profitA = 30;
int: profitB = 10;

int: maxHours = 40;
int: hoursPerKgA = 6;
int: hoursPerKgB = 3;

int: minBRatioToA = 3;          % B >= 3*A

int: storageFactorAtoB = 4;     % A uses 4x storage of B (not binding without B storage limit)
int: maxKgAStored = 4;

% Upper bounds for variable domains (safe bounds from constraints)
int: maxA = min(maxKgAStored, maxHours div hoursPerKgA);  % <= 4 and <= 6
int: maxB = maxHours div hoursPerKgB;                     % <= 13

% Variables
var 0..maxA: A;  % kilograms of product A
var 0..maxB: B;  % kilograms of product B

% Constraints
constraint hoursPerKgA * A + hoursPerKgB * B <= maxHours;

constraint B >= minBRatioToA * A;

constraint A <= maxKgAStored;

% Objective
solve maximize profitA * A + profitB * B;