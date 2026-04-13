int: costA = 100;
int: costB = 80;

int: proteinA = 10;
int: fatA = 8;

int: proteinB = 7;
int: fatB = 15;

int: minProtein = 30;
int: minFat = 50;

var 0.0..1000.0: xA; % kg of Feed A
var 0.0..1000.0: xB; % kg of Feed B

constraint proteinA * xA + proteinB * xB >= minProtein;
constraint fatA * xA + fatB * xB >= minFat;

var 0.0..1000000.0: totalCost = costA * xA + costB * xB;

solve minimize totalCost;

output [
  "FeedA_kg=", show(xA), "\n",
  "FeedB_kg=", show(xB), "\n",
  "TotalCost=", show(totalCost), "\n"
];