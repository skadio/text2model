% Parameters
int: costX = 5;                 % Cost per unit for channel X ($)
int: costY = 3;                 % Cost per unit for channel Y ($)
int: minEffectiveness = 1000;   % Minimum total effectiveness required
int: maxImbalance = 500;        % Maximum allowed imbalance: |X - 2Y| <= 500

% Variables
var 0..maxImbalance + 2*minEffectiveness: xUnits;  % Units allocated to channel X (non-negative integer)
var 0..minEffectiveness: yUnits;                   % Units allocated to channel Y (non-negative integer)
var 0..(costX*(maxImbalance + 2*minEffectiveness) + costY*minEffectiveness): totalCost; % Total campaign cost

% Constraints
% Total cost definition
constraint
  totalCost = costX * xUnits + costY * yUnits;

% Minimum total effectiveness requirement
constraint
  xUnits + yUnits >= minEffectiveness;

% Balanced strategy (imbalance) constraint: |X - 2Y| <= maxImbalance
constraint
  abs(xUnits - 2 * yUnits) <= maxImbalance;

% Objective
solve minimize totalCost;