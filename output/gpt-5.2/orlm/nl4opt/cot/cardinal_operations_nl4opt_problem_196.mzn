% Parameters (with values embedded)
int: budget = 250000;

int: cost_radio = 5000;
int: cost_social = 9150;

int: exposure_radio = 60500;
int: exposure_social = 50000;

int: min_radio = 15;
int: max_radio = 40;
int: min_social = 35;

% Variables
var min_radio..max_radio: radio_ads;
var min_social..100: social_ads; % upper bound tightened by budget constraint below

% Constraints
constraint cost_radio * radio_ads + cost_social * social_ads <= budget;

% Objective
solve maximize exposure_radio * radio_ads + exposure_social * social_ads;

output [
  "radio_ads = ", show(radio_ads), "\n",
  "social_ads = ", show(social_ads), "\n",
  "total_cost = ", show(cost_radio * radio_ads + cost_social * social_ads), "\n",
  "total_exposure = ", show(exposure_radio * radio_ads + exposure_social * social_ads), "\n"
];