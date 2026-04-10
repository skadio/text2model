% Souvenir shop production planning (maximize profit)
include "globals.mzn";

% Data (embedded)
int: wood_avail = 5000;      % grams
int: plastic_avail = 4000;   % grams

int: wood_elephant = 50;
int: plastic_elephant = 20;
int: profit_elephant = 5;

int: wood_tiger = 40;
int: plastic_tiger = 30;
int: profit_tiger = 4;

% Decision variables: number to make (nonnegative integers)
var 0..(wood_avail div wood_elephant): elephants;
var 0..(wood_avail div wood_tiger): tigers;

% Resource constraints
constraint wood_elephant * elephants + wood_tiger * tigers <= wood_avail;
constraint plastic_elephant * elephants + plastic_tiger * tigers <= plastic_avail;

% Objective: maximize profit
var int: profit = profit_elephant * elephants + profit_tiger * tigers;

solve maximize profit;

output [
  "elephants = ", show(elephants), "\n",
  "tigers    = ", show(tigers), "\n",
  "profit    = $", show(profit), "\n",
  "wood_used = ", show(wood_elephant * elephants + wood_tiger * tigers), " g\n",
  "plastic_used = ", show(plastic_elephant * elephants + plastic_tiger * tigers), " g\n"
];