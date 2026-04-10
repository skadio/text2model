int: cow_sell = 500;
int: sheep_sell = 200;
int: chicken_sell = 8;

int: cow_feed = 100;
int: sheep_feed = 80;
int: chicken_feed = 5;

int: cow_profit = cow_sell - cow_feed;         % 400
int: sheep_profit = sheep_sell - sheep_feed;   % 120
int: chicken_profit = chicken_sell - chicken_feed; % 3

int: cow_manure = 10;
int: sheep_manure = 5;
int: chicken_manure = 3;

int: manure_cap = 800;
int: chicken_max = 50;
int: cow_min = 10;
int: sheep_min = 20;
int: animal_total_max = 100;

var cow_min..animal_total_max: cows;
var sheep_min..animal_total_max: sheep;
var 0..chicken_max: chickens;

constraint cow_manure * cows + sheep_manure * sheep + chicken_manure * chickens <= manure_cap;
constraint cows + sheep + chickens <= animal_total_max;

var int: total_profit = cow_profit * cows + sheep_profit * sheep + chicken_profit * chickens;

solve maximize total_profit;

output [
  "cows=", show(cows), "\n",
  "sheep=", show(sheep), "\n",
  "chickens=", show(chickens), "\n",
  "total_profit=", show(total_profit), "\n"
];