% Parameters
% Dose rates (units per minute) delivered by each beam to each region
float: pancreas_rate_beam1 = 0.3;
float: skin_rate_beam1     = 0.2;
float: tumor_rate_beam1    = 0.6;

float: pancreas_rate_beam2 = 0.2;
float: skin_rate_beam2     = 0.1;
float: tumor_rate_beam2    = 0.4;

% Clinical limits
float: max_skin_dose  = 4.0;  % at most 4 units to skin
float: min_tumor_dose = 3.0;  % at least 3 units to tumor

% Safe upper bounds on beam times (broad bounds for search)
float: max_time_beam1 = 20.0;
float: max_time_beam2 = 30.0;

% Variables
% Minutes to apply each beam (nonnegative)
var 0.0..max_time_beam1: minutes_beam1;
var 0.0..max_time_beam2: minutes_beam2;

% Constraints
% Skin dose limit: total dose to skin from both beams must not exceed maximum
constraint
  skin_rate_beam1 * minutes_beam1 + skin_rate_beam2 * minutes_beam2
  <= max_skin_dose;

% Tumor dose requirement: total dose to tumor from both beams must meet minimum
constraint
  tumor_rate_beam1 * minutes_beam1 + tumor_rate_beam2 * minutes_beam2
  >= min_tumor_dose;

% Objective
% Minimize total dose received by the pancreas
solve minimize pancreas_rate_beam1 * minutes_beam1
             + pancreas_rate_beam2 * minutes_beam2;