% Parameters
int: budget = 250000;
int: cost_radio = 5000;
int: cost_social = 9150;

int: exposure_radio = 60500;
int: exposure_social = 50000;

int: min_radio = 15;
int: max_radio = 40;
int: min_social = 35;

% Variables
var min_radio..max_radio: n_radio;
var min_social..(budget div cost_social): n_social;

var 0..(exposure_radio * max_radio + exposure_social * (budget div cost_social)): total_exposure;

% Constraints
constraint cost_radio * n_radio + cost_social * n_social <= budget;

constraint total_exposure = exposure_radio * n_radio + exposure_social * n_social;

% Objective
solve maximize total_exposure;