% Data parameters (to be provided in the .dzn file)
int: P;
float: Cash;
array[1..P] of int: Hour;             % Machine hours required per unit for each product
array[1..P] of int: Cost;             % Production cost per unit for each product
array[1..P] of int: Price;            % Selling price per unit for each product
array[1..P] of float: InvestPercentage; % Percentage of the selling price that must be reinvested per unit
int: UpgradeHours;                    % Extra machine hours that become available if upgrade is performed
int: UpgradeCost;                     % Cash cost for performing the upgrade
int: AvailableHours;                  % Base machine hours available

% Decision variables
% produced[i]: number of units produced for product i;
% Upper bound (e.g., 10000) is chosen arbitrarily, production is naturally limited by cash and capacity.
array[1..P] of var 0..10000: produced;

% upgrade: decision to perform machinery upgrade (0 = no, 1 = yes)
var 0..1: upgrade;

% Constraints

% 1. Machine capacity: Total production hours must not exceed the available machine hours.
constraint 
   sum(i in 1..P)( Hour[i] * produced[i] )
   <= AvailableHours + upgrade * UpgradeHours;

% 2. Cash availability: The cash used for production and the upgrade must not exceed available Cash.
% Each produced unit of product i requires a cash investment of [Cost[i] + InvestPercentage[i]*Price[i]].
constraint 
   sum(i in 1..P)( (Cost[i] + InvestPercentage[i] * Price[i]) * produced[i] ) 
   + upgrade * UpgradeCost <= Cash;

% Objective: Maximize total net income.
% For product i the net income per unit is the selling price reduced by:
%   - the production cost, and 
%   - the part of the selling price that must be reinvested.
% Also, if an upgrade is performed, its cost reduces net income.
% Thus, net income = sum_i produced[i]*(Price[i]*(1 - InvestPercentage[i]) - Cost[i]) - upgrade*UpgradeCost.
var float: netIncome = 
      sum(i in 1..P)( produced[i] * ( Price[i]*(1.0 - InvestPercentage[i]) - Cost[i] ) )  
      - upgrade * UpgradeCost;

solve maximize netIncome;

output [
  "Produced: ", show(produced), "\n",
  "Upgrade chosen: ", show(upgrade), "\n",
  "Net Income: ", show(netIncome), "\n"
];