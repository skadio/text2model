% Advertising mix optimization (embedded data)

% Data
int: budget = 250000;
int: cost_radio = 5000;
int: cost_social = 9150;

int: exposure_radio = 60500;
int: exposure_social = 50000;

int: radio_min = 15;
int: radio_max = 40;
int: social_min = 35;

% Decision variables
var radio_min..radio_max: radio_ads;
var social_min..(budget div cost_social): social_ads; % safe upper bound

% Budget constraint
constraint cost_radio * radio_ads + cost_social * social_ads <= budget;

% Objective: maximize total exposure
var int: total_exposure = exposure_radio * radio_ads + exposure_social * social_ads;

solve maximize total_exposure;

output [
  "Radio ads = ", show(radio_ads), "\n",
  "Social media ads = ", show(social_ads), "\n",
  "Total cost = ", show(cost_radio * radio_ads + cost_social * social_ads), "\n",
  "Total exposure = ", show(total_exposure), "\n"
];