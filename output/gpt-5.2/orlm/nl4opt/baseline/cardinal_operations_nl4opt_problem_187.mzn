% Vitamin shots and pills production optimization

% Resource requirements per batch
int: C_shots = 30;
int: D_shots = 40;
int: C_pills = 50;
int: D_pills = 30;

% Resource availability
int: C_avail = 1200;
int: D_avail = 1500;

% People supplied per batch
int: people_shots = 10;
int: people_pills = 7;

% Limits / relations
int: max_shots = 10;

var 0..max_shots: shots;
var 0..1000: pills; % safe upper bound; constrained by resources anyway

constraint C_shots * shots + C_pills * pills <= C_avail;
constraint D_shots * shots + D_pills * pills <= D_avail;

% Pills must be more than shots
constraint pills > shots;

var int: total_people = people_shots * shots + people_pills * pills;

solve maximize total_people;

output [
  "shots_batches=", show(shots), "\n",
  "pills_batches=", show(pills), "\n",
  "total_people=", show(total_people), "\n"
];