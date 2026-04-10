% Advertising mix optimization (maximize exposure) with embedded data

int: budget = 250000;

int: cost_radio = 5000;
int: cost_social = 9150;

int: exposure_radio = 60500;
int: exposure_social = 50000;

int: min_radio = 15;
int: max_radio = 40;
int: min_social = 35;

var min_radio..max_radio: radio_ads;
var min_social..(budget div cost_social): social_ads;

constraint cost_radio * radio_ads + cost_social * social_ads <= budget;

var int: total_exposure = exposure_radio * radio_ads + exposure_social * social_ads;

solve maximize total_exposure;

output [
  "radio_ads = ", show(radio_ads), "\n",
  "social_ads = ", show(social_ads), "\n",
  "total_cost = ", show(cost_radio * radio_ads + cost_social * social_ads), "\n",
  "total_exposure = ", show(total_exposure), "\n"
];