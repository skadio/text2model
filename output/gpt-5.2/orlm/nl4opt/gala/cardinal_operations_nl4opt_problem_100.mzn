% Model trains & planes profit maximization (all data embedded)

include "globals.mzn";

% Data
int: wood_avail  = 120;
int: paint_avail = 90;

int: wood_train  = 3;
int: paint_train = 3;
int: profit_train = 8;

int: wood_plane  = 4;
int: paint_plane = 2;
int: profit_plane = 10;

% Decision variables: number of each model to make (nonnegative integers)
var 0..wood_avail div min(wood_train, wood_plane): trains;
var 0..wood_avail div min(wood_train, wood_plane): planes;

% Resource constraints
constraint wood_train * trains + wood_plane * planes <= wood_avail;
constraint paint_train * trains + paint_plane * planes <= paint_avail;

% Objective: maximize profit
var int: profit = profit_train * trains + profit_plane * planes;

solve maximize profit;

output [
  "Trains = ", show(trains), "\n",
  "Planes = ", show(planes), "\n",
  "Profit = $", show(profit), "\n",
  "Wood used = ", show(wood_train*trains + wood_plane*planes), " / ", show(wood_avail), "\n",
  "Paint used = ", show(paint_train*trains + paint_plane*planes), " / ", show(paint_avail), "\n"
];