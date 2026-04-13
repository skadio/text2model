include "globals.mzn";

%----------------------------
% Input data
%----------------------------
int: P;                              % number of products
int: Cash;                           % initial cash available
array[1..P] of int: Hour;            % machine hours per unit
array[1..P] of int: Cost;            % production cost per unit
array[1..P] of int: Price;           % selling price per unit
array[1..P] of float: InvestPercentage; % fraction of sales revenue available as cash this period

int: UpgradeHours;                   % extra hours gained if upgrade is performed
int: UpgradeCost;                    % cash cost of upgrade
int: AvailableHours;                 % base available machine hours

%----------------------------
% Decision variables
%----------------------------
% Production quantity (unlimited demand, bounded by cash/hours)
array[1..P] of var 0..1000000000: x;

% Whether to upgrade machinery (0/1)
var 0..1: upgrade;

%----------------------------
% Derived expressions
%----------------------------
var int: total_hours = sum(i in 1..P)(Hour[i] * x[i]);
var int: prod_cost   = sum(i in 1..P)(Cost[i] * x[i]);
var int: revenue     = sum(i in 1..P)(Price[i] * x[i]);

% Cash available for this period: initial cash + reinvestable fraction of revenues - upgrade cash cost
var float: reinvest_cash = sum(i in 1..P)(InvestPercentage[i] * int2float(Price[i]) * int2float(x[i]));
var float: cash_available = int2float(Cash) + reinvest_cash - int2float(UpgradeCost) * int2float(upgrade);

% Total net income: revenue - production cost - upgrade cost
var int: net_income = revenue - prod_cost - UpgradeCost * upgrade;

%----------------------------
% Constraints
%----------------------------
% Machine capacity (upgrade adds hours)
constraint total_hours <= AvailableHours + UpgradeHours * upgrade;

% Cash availability for production spending (and upgrade cost already subtracted)
constraint int2float(prod_cost) <= cash_available;

%----------------------------
% Objective
%----------------------------
solve maximize net_income;

%----------------------------
% Output
%----------------------------
output [
  "upgrade = ", show(upgrade), "\n",
  "x = ", show(x), "\n",
  "total_hours = ", show(total_hours), " / ", show(AvailableHours + UpgradeHours * upgrade), "\n",
  "prod_cost = ", show(prod_cost), "\n",
  "revenue = ", show(revenue), "\n",
  "reinvest_cash = ", show(reinvest_cash), "\n",
  "cash_available = ", show(cash_available), "\n",
  "net_income = ", show(net_income), "\n"
];