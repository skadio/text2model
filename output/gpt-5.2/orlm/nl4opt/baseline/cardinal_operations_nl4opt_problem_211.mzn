int: plastic_available = 1000;
int: solder_available  = 250;

int: plastic_mech = 5;
int: solder_mech  = 2;

int: plastic_std = 2;
int: solder_std  = 1;

int: min_standard = 30;

var 0..plastic_available: mech;
var min_standard..plastic_available: std;

constraint plastic_mech * mech + plastic_std * std <= plastic_available;
constraint solder_mech  * mech + solder_std  * std <= solder_available;

% "aims to have five times as many mechanical than standard keyboards"
constraint mech = 5 * std;

solve maximize mech + std;

output [
  "mechanical=", show(mech), "\n",
  "standard=", show(std), "\n",
  "total=", show(mech + std), "\n"
];