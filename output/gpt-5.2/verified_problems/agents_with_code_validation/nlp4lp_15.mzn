% Parameters
int: P;                                      % Number of products
set of int: PRODUCTS = 1..P;                 % Index set of products

int: Cash;                                   % Initial cash available for investment
array[PRODUCTS] of int: Hour;                % Machine hours required per unit of product i
array[PRODUCTS] of int: Cost;                % Production cost per unit of product i
array[PRODUCTS] of int: Price;               % Selling price per unit of product i
array[PRODUCTS] of float: InvestPercentage;  % Fraction of sales revenue reinvested for product i

int: UpgradeHours;                           % Extra machine hours gained if upgrading is done
int: UpgradeCost;                            % Cash cost to perform the upgrade
int: AvailableHours;                         % Base total available machine hours

% -----------------------
% Float scaling to avoid Float::linear "Number out of limits"
% -----------------------
int: SCALE = 1000; % precision for percentages/money computations in integers

array[PRODUCTS] of int: InvestPermil =
  [ round(InvestPercentage[i] * SCALE) | i in PRODUCTS ];

% Upper bound on total revenue from hours limit (safe integer bound)
int: MaxRevenue =
  sum(i in PRODUCTS)(
    (AvailableHours + UpgradeHours) div max(1, Hour[i]) * Price[i]
  );

% Variables
array[PRODUCTS] of var 0..(AvailableHours + UpgradeHours): Produce; % bounded nonnegative
var 0..1: DoUpgrade;

var 0..(AvailableHours + UpgradeHours): TotalHoursUsed;
var 0..(Cash + UpgradeCost + MaxRevenue): TotalCashSpent;

% Total reinvestment cash, scaled by SCALE
var 0..(MaxRevenue * SCALE): TotalReinvestCashScaled;

var int: TotalNetIncome;

% Constraints

% Machine-hours accounting and capacity (with optional upgrade)
constraint
  TotalHoursUsed = sum(i in PRODUCTS)(Hour[i] * Produce[i]);

constraint
  TotalHoursUsed <= AvailableHours + UpgradeHours * DoUpgrade;

% Cash spending accounting (production costs + optional upgrade cost)
constraint
  TotalCashSpent = sum(i in PRODUCTS)(Cost[i] * Produce[i]) + UpgradeCost * DoUpgrade;

% Reinvestment cash generated from sales revenue (scaled integer)
constraint
  TotalReinvestCashScaled =
    sum(i in PRODUCTS)(InvestPermil[i] * (Price[i] * Produce[i]));

% Cash availability constraint: spending limited by initial cash + reinvested cash
% TotalReinvestCashScaled represents (reinvest cash) * SCALE
constraint
  TotalCashSpent * SCALE <= Cash * SCALE + TotalReinvestCashScaled;

% Net income definition: revenue - production cost - upgrade cost
constraint
  TotalNetIncome =
    sum(i in PRODUCTS)((Price[i] - Cost[i]) * Produce[i]) - UpgradeCost * DoUpgrade;

% Objective
solve maximize TotalNetIncome;