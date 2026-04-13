% Parameters (with values embedded)
int: wood_available = 120;
int: paint_available = 90;

int: wood_per_train = 3;
int: paint_per_train = 3;
int: wood_per_plane = 4;
int: paint_per_plane = 2;

int: profit_train = 8;
int: profit_plane = 10;

% Variables
var 0..(wood_available div wood_per_train): trains;
var 0..(wood_available div wood_per_plane): planes;
var 0..(profit_train*(wood_available div wood_per_train) + profit_plane*(wood_available div wood_per_plane)): profit;

% Constraints
constraint wood_per_train * trains + wood_per_plane * planes <= wood_available;
constraint paint_per_train * trains + paint_per_plane * planes <= paint_available;
constraint profit = profit_train * trains + profit_plane * planes;

% Objective
solve maximize profit;

output [
  "trains = ", show(trains), "\n",
  "planes = ", show(planes), "\n",
  "profit = ", show(profit), "\n"
];