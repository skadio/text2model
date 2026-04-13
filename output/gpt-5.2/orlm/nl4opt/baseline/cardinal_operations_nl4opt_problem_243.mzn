% Lamp production profit maximization (all data embedded)

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

var int: total_profit = profit_desk * desk + profit_night * night;

solve maximize total_profit;

output [
  "desk_lamps = ", show(desk), "\n",
  "night_lamps = ", show(night), "\n",
  "total_lamps = ", show(desk + night), "\n",
  "profit = $", show(total_profit), "\n"
];