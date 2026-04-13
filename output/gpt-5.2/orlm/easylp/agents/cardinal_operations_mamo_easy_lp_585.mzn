% Parameters
% Cost per unit effectiveness (in thousands)
float: cost_tv     = 0.5;
float: cost_radio  = 0.6;
float: cost_social = 0.8;
float: cost_out    = 1.2;

% Upper bounds on allocations (whole units)
int: max_tv     = 700;
int: max_radio  = 600;
int: max_social = 500;
int: max_out    = 400;

% Constraint thresholds
int: min_tv_radio_sum     = 500; % TV + Radio >= 500
int: max_social_radio_diff = 200; % |Social - Radio| <= 200
int: min_out_minus_tv     = 100; % Outdoor - TV >= 100
int: max_social_out_sum   = 800; % Social + Outdoor <= 800


% Variables
% Budget allocations (whole numbers)
var 0..max_tv:     tv_budget;
var 0..max_radio:  radio_budget;
var 0..max_social: social_budget;
var 0..max_out:    outdoor_budget;

% Total cost (in thousands)
var float: total_cost;


% Constraints
% --- Cost definition ---
% Define total cost from channel allocations and per-unit costs
constraint
  total_cost =
    cost_tv     * int2float(tv_budget) +
    cost_radio  * int2float(radio_budget) +
    cost_social * int2float(social_budget) +
    cost_out    * int2float(outdoor_budget);

% --- Reach requirement (TV + Radio) ---
% Ensure sufficient reach via traditional channels
constraint
  tv_budget + radio_budget >= min_tv_radio_sum;

% --- Balanced traditional vs digital mix (Social vs Radio) ---
% Keep the difference between Social Media and Radio within the allowed limit
constraint
  abs(social_budget - radio_budget) <= max_social_radio_diff;

% --- Outdoor visibility strategy (Outdoor vs TV) ---
% Outdoor must exceed TV by at least the specified margin
constraint
  outdoor_budget - tv_budget >= min_out_minus_tv;

% --- Resource limitation (Social + Outdoor) ---
% Cap combined allocation to Social Media and Outdoor
constraint
  social_budget + outdoor_budget <= max_social_out_sum;


% Objective
solve minimize total_cost;