% Model train/plane production (embedded data)

int: wood_available = 120;
int: paint_available = 90;

int: wood_train = 3;
int: paint_train = 3;
int: profit_train = 8;

int: wood_plane = 4;
int: paint_plane = 2;
int: profit_plane = 10;

var 0..wood_available div wood_train: trains;
var 0..wood_available div wood_plane: planes;

constraint wood_train * trains + wood_plane * planes <= wood_available;
constraint paint_train * trains + paint_plane * planes <= paint_available;

var int: profit = profit_train * trains + profit_plane * planes;

solve maximize profit;

output [
  "trains=", show(trains), "\n",
  "planes=", show(planes), "\n",
  "profit=", show(profit), "\n"
];