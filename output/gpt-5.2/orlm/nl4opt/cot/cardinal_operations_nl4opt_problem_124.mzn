% Parameters (with values embedded)
int: gems_required = 800;
int: water_available = 700;

int: gems_high = 50;
int: water_high = 50;

int: gems_low = 30;
int: water_low = 20;

float: max_high_fraction = 0.40;
int: min_low_drills = 10;

% Variables
var 0..gems_required div gems_high + 100: high; % high-intensity drills
var min_low_drills..gems_required div gems_low + 100: low; % low-intensity drills

% Constraints
constraint gems_high * high + gems_low * low >= gems_required;
constraint water_high * high + water_low * low <= water_available;

% At most 40% of drills are high intensity: high <= 0.4*(high+low)
constraint 5 * high <= 2 * (high + low);

% Objective
solve minimize high + low;