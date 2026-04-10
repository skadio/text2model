% Parameters
% Weekly minimum demand (sq ft)
int: min_laminate = 15000;
int: min_carpets  = 5000;

% Weekly shipping contract minimum total production (sq ft)
int: min_total = 50000;

% Weekly maximum production due to raw material shortage (sq ft)
int: max_laminate = 40000;
int: max_carpets  = 20000;

% Profit per square foot ($/sq ft)
float: profit_laminate = 2.1;
float: profit_carpets  = 3.3;


% Variables
% Production quantities (sq ft per week)
var min_laminate..max_laminate: laminate_sqft;  % laminate planks produced
var min_carpets..max_carpets: carpets_sqft;     % carpets produced


% Constraints
% Minimum demand constraints (redundant with variable domains; kept for clarity)
constraint laminate_sqft >= min_laminate;
constraint carpets_sqft  >= min_carpets;

% Maximum production constraints (redundant with variable domains; kept for clarity)
constraint laminate_sqft <= max_laminate;
constraint carpets_sqft  <= max_carpets;

% Shipping contract: minimum total weekly production
constraint laminate_sqft + carpets_sqft >= min_total;


% Objective
solve maximize profit_laminate * laminate_sqft + profit_carpets * carpets_sqft;