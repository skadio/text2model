% Parameters (embedded data)
int: cost_stock = 5;
int: cost_rent  = 4;
int: cost_wages = 3;
int: cost_util  = 2;

int: min_stock = 1000;
int: min_rent  = 500;
int: min_wages = 1200;
int: min_util  = 300;

int: diff_stock_rent_min  = 1000;
int: diff_stock_wages_min = 1500;

int: wages_util_max = 5000;
int: rent_util_sum  = 2000;

% Decision variables (finite bounds inferred from constraints)
var min_stock..10000: stock;
var min_rent..(rent_util_sum - min_util): rent;     % rent <= 1700
var min_wages..(wages_util_max - min_util): wages;  % wages <= 4700
var min_util..(rent_util_sum - min_rent): util;     % util <= 1500

var int: total_cost;

% Constraints
constraint abs(stock - rent) >= diff_stock_rent_min;
constraint wages + util <= wages_util_max;
constraint abs(stock - wages) >= diff_stock_wages_min;
constraint rent + util = rent_util_sum;

% Objective
constraint total_cost = cost_stock * stock
                      + cost_rent  * rent
                      + cost_wages * wages
                      + cost_util  * util;

solve minimize total_cost;