% Doctor's office thermometer scheduling (simple integer optimization)

int: open_minutes = 15000;
int: t_e = 3;          % minutes per electronic reading
int: t_r = 2;          % minutes per regular reading
int: min_regular = 50; % cooldown requirement

% Decision variables: number of patients served by each thermometer type
var 0..open_minutes div t_e: e;  % electronic patients
var 0..open_minutes div t_r: r;  % regular patients

% Time capacity
constraint t_e * e + t_r * r <= open_minutes;

% Accuracy requirement: at least twice as many electronic as regular
constraint e >= 2 * r;

% Cooldown requirement: at least 50 regular readings
constraint r >= min_regular;

% Objective: maximize total patients
var 0..open_minutes: total = e + r;
solve maximize total;

output [
  "Electronic = ", show(e), "\n",
  "Regular    = ", show(r), "\n",
  "Total      = ", show(total), "\n",
  "MinutesUsed= ", show(t_e*e + t_r*r), " / ", show(open_minutes), "\n"
];