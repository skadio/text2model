% Parameters
% Demand minima (square feet per week)
int: min_hardwood_demand = 20000;
int: min_vinyl_demand    = 10000;

% Total shipment minimum (square feet per week)
int: min_total_shipment  = 60000;

% Production capacity maxima (square feet per week)
int: max_hardwood_prod   = 50000;
int: max_vinyl_prod      = 30000;

% Profit per square foot (dollars)
float: profit_hardwood   = 2.5;
float: profit_vinyl      = 3.0;

% Variables
% Weekly production quantities (square feet)
var 0..max_hardwood_prod: hardwood_sqft;
var 0..max_vinyl_prod:    vinyl_sqft;

% Weekly total profit (dollars), bounded using production maxima
var 0.0..(profit_hardwood * int2float(max_hardwood_prod)
        + profit_vinyl   * int2float(max_vinyl_prod)): total_profit;

% Constraints
%--- Demand satisfaction constraints (minimum weekly demand) ---
constraint hardwood_sqft >= min_hardwood_demand;  % Meet hardwood demand
constraint vinyl_sqft    >= min_vinyl_demand;     % Meet vinyl demand

%--- Shipping contract constraint (minimum total shipped each week) ---
constraint hardwood_sqft + vinyl_sqft >= min_total_shipment;

%--- Profit definition constraint (link total_profit to production decisions) ---
constraint total_profit =
    profit_hardwood * int2float(hardwood_sqft)
  + profit_vinyl    * int2float(vinyl_sqft);

% Objective
solve maximize total_profit;