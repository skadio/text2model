% Parameters
% Unit costs (dollars per unit)
int: cost_advertising = 5;
int: cost_pr          = 2;
int: cost_online      = 3;
int: cost_offline     = 4;

% Constraint constants
int: max_advertising_plus_pr            = 10000;
int: min_online_plus_offline            = 2000;
int: max_abs_advertising_minus_online   = 5000;
int: min_pr_minus_offline               = -1000;

% Upper bounds on allocations (units)
int: ub_advertising = 6000;
int: ub_pr          = 4000;
int: ub_online      = 3000;
int: ub_offline     = 7000;


% Variables
% Integer allocations (whole-number units), non-negative and upper-bounded
var 0..ub_advertising: advertising_units;
var 0..ub_pr:          pr_units;
var 0..ub_online:      online_units;
var 0..ub_offline:     offline_units;

% Total cost (dollars), integer since all costs and units are integers
var 0..(cost_advertising*ub_advertising
      + cost_pr*ub_pr
      + cost_online*ub_online
      + cost_offline*ub_offline): total_cost;


% Constraints
% Total cost definition (linear cost accumulation)
constraint
  total_cost =
    cost_advertising * advertising_units +
    cost_pr          * pr_units +
    cost_online      * online_units +
    cost_offline     * offline_units;

% Budget cap on Advertising + PR
constraint
  advertising_units + pr_units <= max_advertising_plus_pr;

% Minimum spend on Online + Offline marketing
constraint
  online_units + offline_units >= min_online_plus_offline;

% Bound the absolute difference between Advertising and Online
constraint
  abs(advertising_units - online_units) <= max_abs_advertising_minus_online;

% PR - Offline must be at least the given minimum (can be negative)
constraint
  pr_units - offline_units >= min_pr_minus_offline;


% Objective
solve minimize total_cost;