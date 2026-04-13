% Farm crop allocation - maximize profit

int: total_acres = 100;

int: profit_corn = 1500;
int: profit_wheat = 1200;
int: profit_soybeans = 1800;
int: profit_sorghum = 1600;

var 0..total_acres: corn;
var 0..total_acres: wheat;
var 0..total_acres: soybeans;
var 0..total_acres: sorghum;

constraint corn + wheat + soybeans + sorghum = total_acres;

% Corn at least twice wheat
constraint corn >= 2 * wheat;

% Soybeans at least half sorghum  (2*soybeans >= sorghum)
constraint 2 * soybeans >= sorghum;

% Wheat must be three times sorghum
constraint wheat = 3 * sorghum;

var int: total_profit =
  profit_corn * corn +
  profit_wheat * wheat +
  profit_soybeans * soybeans +
  profit_sorghum * sorghum;

solve maximize total_profit;

output [
  "corn=", show(corn), " acres\n",
  "wheat=", show(wheat), " acres\n",
  "soybeans=", show(soybeans), " acres\n",
  "sorghum=", show(sorghum), " acres\n",
  "total_profit=$", show(total_profit), "\n"
];