% Parameters
% Unit costs ($ per unit)
int: cost_advertising = 3;
int: cost_promotion   = 2;
int: cost_sales       = 1;

% Requirement thresholds
int: min_ad_plus_pr   = 10000;   % Advertising + Promotion >= 10,000
int: max_2ad_plus_sa  = 50000;   % 2*Advertising + Sales <= 50,000
int: min_sa_minus_pr  = 2000;    % Sales - Promotion >= 2,000

% Upper bounds on allocations
int: max_advertising  = 30000;
int: max_promotion    = 20000;
int: max_sales        = 25000;

% Variables
% Integer, nonnegative allocations (bounded)
var 0..max_advertising: advertising;
var 0..max_promotion:   promotion;
var 0..max_sales:       sales;

% Total cost (bounded for better propagation)
var 0..(cost_advertising * max_advertising
      + cost_promotion   * max_promotion
      + cost_sales       * max_sales): total_cost;

% Constraints
% Resource requirement constraints
constraint advertising + promotion >= min_ad_plus_pr;
constraint 2 * advertising + sales <= max_2ad_plus_sa;
constraint sales - promotion >= min_sa_minus_pr;

% Total cost definition constraint
constraint total_cost =
    cost_advertising * advertising
  + cost_promotion   * promotion
  + cost_sales       * sales;

% Objective
solve minimize total_cost;