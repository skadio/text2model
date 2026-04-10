% Parameters
int: cost_ad = 3;
int: cost_pr = 2;
int: cost_sa = 1;

int: min_ad_pr = 10000;
int: max_2ad_sa = 50000;
int: min_sa_pr = 2000;

int: max_ad = 30000;
int: max_pr = 20000;
int: max_sa = 25000;

% Variables
var 0..max_ad: Advertising;
var 0..max_pr: Promotion;
var 0..max_sa: Sales;

var int: TotalCost;

% Constraints
constraint Advertising + Promotion >= min_ad_pr;
constraint 2 * Advertising + Sales <= max_2ad_sa;
constraint Sales - Promotion >= min_sa_pr;

constraint TotalCost = cost_ad * Advertising + cost_pr * Promotion + cost_sa * Sales;

% Objective
solve minimize TotalCost;