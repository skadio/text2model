% Parameters
int: P;                               % Number of products
set of int: PRODUCTS = 1..P;          % Index set of products

int: Cash;                            % Initial cash available for investment
array[PRODUCTS] of int: Hour;         % Machine hours required per unit of product i
array[PRODUCTS] of int: Cost;         % Production cost per unit of product i
array[PRODUCTS] of int: Price;        % Selling price for one unit of product i
array[PRODUCTS] of float: InvestPercentage; % Fraction of sales revenue available to finance operations (0..1)

int: UpgradeHours;                    % Additional machine hours gained if upgrading
int: UpgradeCost;                     % Cash cost to perform upgrade
int: AvailableHours;                  % Base machine hours available in the period


% Variables
array[PRODUCTS] of var int: Produce;  % Units produced of each product i (non-negative)
var bool: DoUpgrade;                  % True if machinery is upgraded, false otherwise

var int: TotalHoursUsed;              % Total machine hours used
var int: TotalBaseProductionCost;     % Total production cost across products
var int: TotalRevenue;                % Total sales revenue across products
var float: TotalReinvestedCash;       % Total cash made available from reinvested revenue
var int: TotalNetIncome;              % Total net income (revenue - production cost - upgrade cost)


% Constraints
% --- Domain constraints (non-negativity / basic feasibility) ---
constraint
  forall(i in PRODUCTS) (
    Produce[i] >= 0
  );

% --- Link aggregate variables to decisions (hours, costs, revenue) ---
constraint
  TotalHoursUsed = sum(i in PRODUCTS)(Hour[i] * Produce[i]);

constraint
  TotalBaseProductionCost = sum(i in PRODUCTS)(Cost[i] * Produce[i]);

constraint
  TotalRevenue = sum(i in PRODUCTS)(Price[i] * Produce[i]);

% --- Reinvested cash from revenues (float, percentage per product) ---
constraint
  TotalReinvestedCash =
    sum(i in PRODUCTS)(InvestPercentage[i] * int2float(Price[i] * Produce[i]));

% --- Cash availability constraint (initial cash + reinvested revenue finances production + optional upgrade) ---
constraint
  int2float(TotalBaseProductionCost + UpgradeCost * bool2int(DoUpgrade))
  <= int2float(Cash) + TotalReinvestedCash;

% --- Machine capacity constraint (base hours plus optional upgrade hours) ---
constraint
  TotalHoursUsed <= AvailableHours + UpgradeHours * bool2int(DoUpgrade);

% --- Net income definition (revenue - production cost - upgrade cost if done) ---
constraint
  TotalNetIncome =
    TotalRevenue - TotalBaseProductionCost - UpgradeCost * bool2int(DoUpgrade);


% Objective
solve maximize TotalNetIncome;