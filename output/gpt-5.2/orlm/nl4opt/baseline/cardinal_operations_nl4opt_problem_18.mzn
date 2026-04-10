% Souvenir shop production optimization: elephants and tigers

int: wood_available = 5000;
int: plastic_available = 4000;

int: wood_elephant = 50;
int: plastic_elephant = 20;

int: wood_tiger = 40;
int: plastic_tiger = 30;

int: profit_elephant = 5;
int: profit_tiger = 4;

var 0..wood_available div wood_elephant: elephants;
var 0..wood_available div wood_tiger: tigers;

constraint wood_elephant * elephants + wood_tiger * tigers <= wood_available;
constraint plastic_elephant * elephants + plastic_tiger * tigers <= plastic_available;

var int: profit = profit_elephant * elephants + profit_tiger * tigers;

solve maximize profit;

output [
  "elephants=", show(elephants), "\n",
  "tigers=", show(tigers), "\n",
  "profit=$", show(profit), "\n"
];