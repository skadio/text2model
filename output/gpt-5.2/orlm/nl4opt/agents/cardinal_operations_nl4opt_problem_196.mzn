% Parameters
int: budget = 250000;                 % Total advertising budget ($)
int: cost_radio = 5000;               % Cost per radio ad ($)
int: cost_social = 9150;              % Cost per social media ad ($)
int: exposure_radio = 60500;          % Expected exposure per radio ad (viewers)
int: exposure_social = 50000;         % Expected exposure per social media ad (viewers)

int: min_radio = 15;                  % Minimum number of radio ads
int: max_radio = 40;                  % Maximum number of radio ads
int: min_social = 35;                 % Minimum number of social media ads

% Derived upper bound for social ads (tightens domain)
int: max_social = (budget - min_radio * cost_radio) div cost_social;

% Variables
var min_radio..max_radio: n_radio;      % Number of radio ads to run
var min_social..max_social: n_social;   % Number of social media ads to run

% Constraints
% Budget feasibility: total spend on radio and social media ads must not exceed budget
constraint
  cost_radio * n_radio + cost_social * n_social <= budget;

% Radio ad bounds (redundant with variable domain, kept for clarity/maintenance)
constraint
  min_radio <= n_radio /\ n_radio <= max_radio;

% Social media ad lower bound (redundant with variable domain, kept for clarity/maintenance)
constraint
  n_social >= min_social;

% Objective
solve maximize exposure_radio * n_radio + exposure_social * n_social;