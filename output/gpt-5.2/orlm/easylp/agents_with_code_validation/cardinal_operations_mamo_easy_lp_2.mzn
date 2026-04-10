% Parameters
% Minimum required effectiveness (impact points)
int: min_effectiveness = 100;

% Coefficients for effectiveness calculation
% effectiveness = eff_coef_advertising * advertising + eff_coef_promotion * promotion
int: eff_coef_advertising = 2;
int: eff_coef_promotion  = 3;

% Balance constraint: advertising cannot exceed promotion by more than this amount ($)
int: max_adv_over_promo = 50;

% Impact points contributed per $1 spent (given additional info)
int: impact_per_dollar_advertising = 4;
int: impact_per_dollar_promotion  = 5;

% Upper bound for search (safe big-M)
int: max_spend = 200;


% Variables
% Spend amounts (integers, non-negative)
var 0..max_spend: advertising;  % $ spent on advertising
var 0..max_spend: promotion;    % $ spent on promotion

% Total spend to minimize
var 0..(2*max_spend): total_spend;  % advertising + promotion


% Constraints
% Enforce consistency between stated effectiveness coefficients and impact-per-dollar data.
% This makes the model coherent with "each $ yields 4/5 impact points".
constraint eff_coef_advertising = impact_per_dollar_advertising;
constraint eff_coef_promotion  = impact_per_dollar_promotion;

% --- Effectiveness requirement (minimum impact points) ---
constraint
  eff_coef_advertising * advertising + eff_coef_promotion * promotion
  >= min_effectiveness;

% --- Balanced strategy: advertising cannot exceed promotion by more than $50 ---
constraint
  advertising - promotion <= max_adv_over_promo;

% --- Total spend definition ---
constraint
  total_spend = advertising + promotion;


% Objective
solve minimize total_spend;