% Parameters
int: P;                                 % Number of products
float: Cash;                            % Initial cash available
array[1..P] of int: Hour;               % Hours required per unit of product i
array[1..P] of float: Cost;             % Production cost per unit of product i
array[1..P] of float: Price;            % Selling price per unit of product i
array[1..P] of float: InvestPercentage; % Percentage of revenue available during the period
int: UpgradeHours;                      % Additional machine hours obtained through upgrade
float: UpgradeCost;                     % Cost of upgrading the machinery
int: AvailableHours;                    % Currently available machine hours

% Derived data
array[1..P] of int: MaxProd = [ (AvailableHours + UpgradeHours) div Hour[i] | i in 1..P ];
int: MaxPossible = max(i in 1..P)(MaxProd[i]);

% Decision variables
array[1..P] of var 0..MaxPossible: Produce;   % Units of each product to produce
var 0..1: Upgrade;                            % 1 if the machinery is upgraded, 0 otherwise

% Constraints
constraint forall(i in 1..P)(Produce[i] <= MaxProd[i]);

constraint
    % Machine–hour capacity (with optional upgrade)
    sum(i in 1..P)(Hour[i] * Produce[i]) <= AvailableHours + UpgradeHours * Upgrade;

constraint
    % Cash-flow constraint
    sum(i in 1..P)(Cost[i] * int2float(Produce[i])) + UpgradeCost * int2float(Upgrade)
    <= Cash + sum(i in 1..P)(Price[i] * InvestPercentage[i] * int2float(Produce[i]));

% Objective
solve maximize
    sum(i in 1..P)((Price[i] - Cost[i]) * int2float(Produce[i])) - UpgradeCost * int2float(Upgrade);