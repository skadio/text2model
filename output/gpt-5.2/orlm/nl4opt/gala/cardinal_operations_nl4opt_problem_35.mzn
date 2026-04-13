% Diet optimization: minimize fat while meeting calorie/protein needs
include "globals.mzn";

% Data (embedded from problem statement)
int: calA = 200;   % calories per serving almonds
int: proA = 20;    % protein grams per serving almonds
int: fatA = 15;    % fat grams per serving almonds

int: calC = 300;   % calories per serving cashews
int: proC = 25;    % protein grams per serving cashews
int: fatC = 12;    % fat grams per serving cashews

int: minCal = 10000;
int: minPro = 800;

% Decision variables: number of servings (nonnegative integers)
var 0..100000: almonds;
var 0..100000: cashews;

% Constraints
constraint calA * almonds + calC * cashews >= minCal;
constraint proA * almonds + proC * cashews >= minPro;
constraint almonds >= 2 * cashews;

% Objective: minimize total fat intake
var 0..intmax: totalFat = fatA * almonds + fatC * cashews;
solve minimize totalFat;

output [
  "almonds = ", show(almonds), "\n",
  "cashews = ", show(cashews), "\n",
  "totalFat = ", show(totalFat), "\n",
  "totalCalories = ", show(calA*almonds + calC*cashews), "\n",
  "totalProtein = ", show(proA*almonds + proC*cashews), "\n"
];