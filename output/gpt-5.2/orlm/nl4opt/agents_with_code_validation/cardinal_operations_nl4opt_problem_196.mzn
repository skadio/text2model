% Parameters
int: budget = 250000;                 % Total advertising budget ($)
int: cost_radio = 5000;               % Cost per radio ad ($)
int: cost_social = 9150;              % Cost per social media ad ($)
int: exposure_radio = 60500;          % Expected exposure per radio ad (viewers)
int: exposure_social = 50000;         % Expected exposure per social media ad (viewers)

int: min_radio = 15;                  % Minimum number of radio ads
int: max_radio = 40;                  % Maximum number of radio ads
int: min_social = 35;                 % Minimum number of social media ads

% Upper bound for social ads derived from budget (safe explicit bound)
int: max_social = budget div cost_social;

% Variables
var min_radio..max_radio: num_radio_ads;            % Number of radio ads to run
var min_social..max_social: num_social_media_ads;   % Number of social media ads to run

var 0..(exposure_radio*max_radio + exposure_social*max_social): total_exposure; % Total exposure
var 0..budget: total_cost;                                                    % Total cost

% Constraints
% Compute total cost from decision variables
constraint total_cost =
  cost_radio * num_radio_ads + cost_social * num_social_media_ads;

% Enforce budget limit
constraint total_cost <= budget;

% Compute total exposure from decision variables
constraint total_exposure =
  exposure_radio * num_radio_ads + exposure_social * num_social_media_ads;

% Objective
solve maximize total_exposure;