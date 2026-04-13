% Doctor's office thermometer scheduling / selection problem
% Data embedded in model

int: open_minutes = 15000;

int: time_electronic = 3;
int: time_regular    = 2;

int: min_regular = 50;

% Decision variables: number of patients checked by each thermometer type
var 0..open_minutes div time_electronic: E; % electronic
var 0..open_minutes div time_regular:    R; % regular

% Time capacity
constraint time_electronic * E + time_regular * R <= open_minutes;

% Accuracy requirement: at least twice as many electronic as regular
constraint E >= 2 * R;

% Cooldown requirement: at least 50 patients checked with regular thermometer
constraint R >= min_regular;

% Objective: maximize total patients
var 0..(open_minutes div min(time_electronic, time_regular)): total = E + R;

solve maximize total;

output [
  "Electronic patients = ", show(E), "\n",
  "Regular patients    = ", show(R), "\n",
  "Total patients      = ", show(total), "\n",
  "Minutes used        = ", show(time_electronic*E + time_regular*R), " / ", show(open_minutes), "\n"
];