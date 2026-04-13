% Drug company production planning (embedded data)

% Decision variables: hours to run each factory (can be fractional)
var 0.0..1.0e6: h1; % factory 1 hours
var 0.0..1.0e6: h2; % factory 2 hours

% Data (per hour)
float: allergy1 = 20.0;
float: fever1   = 15.0;
float: allergy2 = 10.0;
float: fever2   = 30.0;

float: rare1 = 20.0;
float: rare2 = 30.0;

% Requirements and limits
float: min_allergy = 700.0;
float: min_fever   = 600.0;
float: rare_avail  = 1000.0;

constraint allergy1*h1 + allergy2*h2 >= min_allergy;
constraint fever1*h1   + fever2*h2   >= min_fever;
constraint rare1*h1    + rare2*h2    <= rare_avail;

% Objective: minimize total time run (sum of hours)
var float: total_time = h1 + h2;
solve minimize total_time;

output [
  "Factory1_hours=", show(h1), "\n",
  "Factory2_hours=", show(h2), "\n",
  "Total_hours=", show(total_time), "\n",
  "Allergy_produced=", show(allergy1*h1 + allergy2*h2), "\n",
  "Fever_produced=", show(fever1*h1 + fever2*h2), "\n",
  "Rare_used=", show(rare1*h1 + rare2*h2), "\n"
];