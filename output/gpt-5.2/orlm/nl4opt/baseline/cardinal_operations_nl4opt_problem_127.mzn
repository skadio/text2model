% Dentist scheduling to minimize pain killer usage

% Data
int: resin_total = 3000;

int: resin_molar = 20;
int: resin_canine = 15;

% Pain killer per cavity (scaled by 10 to avoid decimals)
int: scale = 10;
int: pain_molar = 30;   % 3.0 * 10
int: pain_canine = 23;  % 2.3 * 10

% Decision variables: number of cavities filled
var 0..10000: molars;
var 0..10000: canines;

% Constraints
constraint resin_molar * molars + resin_canine * canines <= resin_total;

% At least 60% canines: canines / (molars+canines) >= 0.6
constraint 10 * canines >= 6 * (molars + canines);

% Must be able to fill at least 45 molars
constraint molars >= 45;

% Objective: minimize total pain killer usage (scaled)
var 0..100000000: total_pain = pain_molar * molars + pain_canine * canines;
solve minimize total_pain;

output [
  "molars=", show(molars), "\n",
  "canines=", show(canines), "\n",
  "total_pain_killer=", show(total_pain / scale), ".", show(total_pain mod scale), "\n",
  "resin_used=", show(resin_molar * molars + resin_canine * canines), "\n"
];