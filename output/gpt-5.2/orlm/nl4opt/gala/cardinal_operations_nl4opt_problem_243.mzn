% Lamp production profit maximization (no external .dzn)

int: min_desk = 30;
int: min_night = 50;

int: max_desk = 150;
int: max_night = 180;

int: min_total = 100;

int: profit_desk = 5;
int: profit_night = 8;

var min_desk..max_desk: desk;
var min_night..max_night: night;

constraint desk + night >= min_total;

var int: profit = profit_desk * desk + profit_night * night;

solve maximize profit;

output [
  "desk = ", show(desk), "\n",
  "night = ", show(night), "\n",
  "profit = ", show(profit), "\n"
];