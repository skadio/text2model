% Budget allocation optimization for four categories
% All data embedded as requested.

include "globals.mzn";

% Decision variables: allocations in whole numbers
var int: stock;
var int: rent;
var int: wages;
var int: utilities;

% Unit costs
int: c_stock = 5;
int: c_rent  = 4;
int: c_wages = 3;
int: c_util  = 2;

% Minimum budget requirements
constraint stock >= 1000;
constraint rent  >= 500;
constraint wages >= 1200;
constraint utilities >= 300;

% Operational/financial constraints
constraint abs(stock - rent) >= 1000;
constraint wages + utilities <= 5000;
constraint abs(stock - wages) >= 1500;
constraint rent + utilities = 2000;

% Objective: minimize total monthly expenditure
var int: total_cost = c_stock*stock + c_rent*rent + c_wages*wages + c_util*utilities;

solve minimize total_cost;

output [
  "stock = ", show(stock), "\n",
  "rent = ", show(rent), "\n",
  "wages = ", show(wages), "\n",
  "utilities = ", show(utilities), "\n",
  "total_cost = ", show(total_cost), "\n"
];