% Keyboard production optimization (embed all data)

include "globals.mzn";

% Data (from problem statement)
int: plastic_avail = 1000;
int: solder_avail  = 250;

int: plastic_mech = 5;
int: solder_mech  = 2;

int: plastic_std  = 2;
int: solder_std   = 1;

int: min_std = 30;

% Decision variables
var 0..plastic_avail div plastic_mech: mech; % mechanical keyboards
var min_std..plastic_avail div plastic_std: std;  % standard keyboards

% Resource constraints
constraint plastic_mech * mech + plastic_std * std <= plastic_avail;
constraint solder_mech  * mech + solder_std  * std <= solder_avail;

% Target ratio: five times as many mechanical as standard
constraint mech = 5 * std;

% Objective: maximize total number of keyboards
var 0..(plastic_avail div min(plastic_mech, plastic_std)) + (plastic_avail div min(plastic_mech, plastic_std)): total;
constraint total = mech + std;

solve maximize total;

output [
  "Mechanical = ", show(mech), "\n",
  "Standard   = ", show(std), "\n",
  "Total      = ", show(total), "\n",
  "Plastic used = ", show(plastic_mech * mech + plastic_std * std), " / ", show(plastic_avail), "\n",
  "Solder used  = ", show(solder_mech * mech + solder_std * std),  " / ", show(solder_avail), "\n"
];