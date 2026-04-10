include "globals.mzn";

% Data (embedded as required)
int: minCalcium = 15;
int: minVitamins = 20;
int: minProtein = 20;

int: costRegular = 20;
int: calRegular  = 4;
int: vitRegular  = 7;
int: proRegular  = 10;

int: costPremium = 35;
int: calPremium  = 12;
int: vitPremium  = 10;
int: proPremium  = 16;

% Decision variables: number of bags of each brand (nonnegative integers)
var 0..100: regularBags;
var 0..100: premiumBags;

% Nutrient constraints
constraint calRegular * regularBags + calPremium * premiumBags >= minCalcium;
constraint vitRegular * regularBags + vitPremium * premiumBags >= minVitamins;
constraint proRegular * regularBags + proPremium * premiumBags >= minProtein;

% Objective: minimize total cost
var int: totalCost = costRegular * regularBags + costPremium * premiumBags;

solve minimize totalCost;

output [
  "regularBags = ", show(regularBags), "\n",
  "premiumBags = ", show(premiumBags), "\n",
  "totalCost = $", show(totalCost), "\n",
  "calcium = ", show(calRegular*regularBags + calPremium*premiumBags), "\n",
  "vitamins = ", show(vitRegular*regularBags + vitPremium*premiumBags), "\n",
  "protein = ", show(proRegular*regularBags + proPremium*premiumBags), "\n"
];