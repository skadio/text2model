% Parameters
% Per-unit costs (USD per unit allocated) for each channel (embedded data)
int: cost_advertising = 5;
int: cost_pr          = 2;
int: cost_online      = 3;
int: cost_offline     = 4;

% Upper limits (max units allocated) for each channel (embedded data)
int: max_advertising = 6000;
int: max_pr          = 4000;
int: max_online      = 3000;
int: max_offline     = 7000;

% Constraint constants (embedded data)
int: max_ad_pr_total     = 10000;  % Advertising + PR <= 10000
int: min_on_off_total    = 2000;   % Online + Offline >= 2000
int: max_diff_ad_online  = 5000;   % |Advertising - Online| <= 5000
int: min_diff_pr_offline = -1000;  % PR - Offline >= -1000

% Variables
% Budget allocations (whole units) for each channel
var 0..max_advertising: advertising_units;
var 0..max_pr:          pr_units;
var 0..max_online:      online_units;
var 0..max_offline:     offline_units;

% Total cost in dollars (integer, since costs and units are integers)
var 0..(cost_advertising * max_advertising
      + cost_pr          * max_pr
      + cost_online      * max_online
      + cost_offline     * max_offline): total_cost_dollars;

% Constraints
% Total cost definition (linear expression from per-unit costs)
constraint total_cost_dollars =
    cost_advertising * advertising_units
  + cost_pr          * pr_units
  + cost_online      * online_units
  + cost_offline     * offline_units;

% Combined allocation cap for Advertising + PR
constraint advertising_units + pr_units <= max_ad_pr_total;

% Minimum combined allocation for Online + Offline
constraint online_units + offline_units >= min_on_off_total;

% Absolute difference bound between Advertising and Online
constraint abs(advertising_units - online_units) <= max_diff_ad_online;

% Lower bound on difference between PR and Offline (PR - Offline >= -1000)
constraint pr_units - offline_units >= min_diff_pr_offline;

% Objective
solve minimize total_cost_dollars;