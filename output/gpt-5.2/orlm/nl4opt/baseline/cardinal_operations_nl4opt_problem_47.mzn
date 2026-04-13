% Lighting installation optimization
% Minimize total number of light changes over a decade

int: min_total_lights = 300;
int: max_electricity = 2000;

int: elec_led = 5;
int: elec_fluor = 8;

int: changes_led = 3;     % per decade
int: changes_fluor = 4;   % per decade

% Decision variables: number of each light installed
var 0..max_electricity div elec_led: led;
var 0..max_electricity div elec_fluor: fluor;

% Constraints
constraint led + fluor >= min_total_lights;
constraint elec_led * led + elec_fluor * fluor <= max_electricity;

% At least 30% of installed lights must be fluorescence:
% fluor / (led + fluor) >= 0.30  <=>  10*fluor >= 3*(led + fluor)  <=>  7*fluor >= 3*led
constraint 7 * fluor >= 3 * led;

% Objective: minimize total number of changes
var int: total_changes = changes_led * led + changes_fluor * fluor;
solve minimize total_changes;

output [
  "LED fixtures: ", show(led), "\n",
  "Fluorescence lamps: ", show(fluor), "\n",
  "Total lights: ", show(led + fluor), "\n",
  "Electricity used: ", show(elec_led * led + elec_fluor * fluor), "\n",
  "Total changes (per decade): ", show(total_changes), "\n"
];