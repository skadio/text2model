% Parameters
int: cost_stock = 5;
int: cost_rent = 4;
int: cost_wages = 3;
int: cost_util = 2;

int: min_stock = 1000;
int: min_rent = 500;
int: min_wages = 1200;
int: min_util = 300;

int: diff_stock_rent = 1000;
int: diff_stock_wages = 1500;

int: max_wages_util_sum = 5000;

int: rent_util_sum_eq = 2000;

% Variables
var min_stock..100000: Stock;
var min_rent..100000: Rent;
var min_wages..100000: Wages;
var min_util..100000: Utilities;

var 0..1000000000: TotalCost;

% Constraints
constraint abs(Stock - Rent) >= diff_stock_rent;
constraint Wages + Utilities <= max_wages_util_sum;
constraint abs(Stock - Wages) >= diff_stock_wages;
constraint Rent + Utilities = rent_util_sum_eq;

% Objective
constraint TotalCost = cost_stock * Stock + cost_rent * Rent + cost_wages * Wages + cost_util * Utilities;
solve minimize TotalCost;