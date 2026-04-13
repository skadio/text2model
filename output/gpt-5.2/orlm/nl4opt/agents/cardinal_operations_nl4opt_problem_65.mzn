% Parameters
% Demand lower bounds (sq ft/week)
int: min_laminate = 15000;
int: min_carpet   = 5000;

% Total shipping requirement (sq ft/week)
int: min_total = 50000;

% Production upper bounds due to raw material limits (sq ft/week)
int: max_laminate = 40000;
int: max_carpet   = 20000;

% Profit per square foot ($/sq ft)
float: profit_laminate = 2.1;
float: profit_carpet   = 3.3;

% Variables
% Weekly production amounts (sq ft/week)
var min_laminate..max_laminate: laminate_sqft;
var min_carpet..max_carpet: carpet_sqft;

% Total weekly profit ($)
var float: total_profit;

% Constraints
% Enforce minimum demand requirements (redundant with domains, kept for clarity)
constraint laminate_sqft >= min_laminate;
constraint carpet_sqft   >= min_carpet;

% Enforce maximum production limits due to raw materials (redundant with domains, kept for clarity)
constraint laminate_sqft <= max_laminate;
constraint carpet_sqft   <= max_carpet;

% Enforce total shipping requirement: at least min_total sq ft shipped weekly
constraint laminate_sqft + carpet_sqft >= min_total;

% Define total weekly profit from production amounts and per-sq-ft profit rates
constraint total_profit = profit_laminate * laminate_sqft + profit_carpet * carpet_sqft;

% Objective
solve maximize total_profit;