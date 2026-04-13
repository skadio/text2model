int: invA = 500;
int: invB = 1000;
int: maxBuyA = 1500;

float: minPropA_I  = 0.50;
float: minPropA_II = 0.60;

int: price_I  = 4800;
int: price_II = 5600;

int: tier1_cap = 500;
int: tier2_cap = 500;
int: tier3_cap = 500;

int: cost1 = 10000;
int: cost2 = 8000;
int: cost3 = 6000;

int: maxTotalProd = invA + invB + maxBuyA;

var 0..maxTotalProd: xI;
var 0..maxTotalProd: xII;

var 0..(invA + maxBuyA): aI;
var 0..(invA + maxBuyA): aII;
var 0..invB: bI;
var 0..invB: bII;

var 0..maxBuyA: buyA;
var 0..tier1_cap: buyA1;
var 0..tier2_cap: buyA2;
var 0..tier3_cap: buyA3;

var int: profit;

constraint xI = aI + bI;
constraint xII = aII + bII;

constraint buyA = buyA1 + buyA2 + buyA3;

constraint aI + aII <= invA + buyA;
constraint bI + bII <= invB;

constraint 2 * aI >= xI;
constraint 5 * aII >= 3 * xII;

constraint profit =
  (price_I * xI + price_II * xII)
  - (cost1 * buyA1 + cost2 * buyA2 + cost3 * buyA3);

solve maximize profit;

output [
  "xI=", show(xI), "\n",
  "xII=", show(xII), "\n",
  "aI=", show(aI), " bI=", show(bI), "\n",
  "aII=", show(aII), " bII=", show(bII), "\n",
  "buyA=", show(buyA), " (", show(buyA1), ",", show(buyA2), ",", show(buyA3), ")\n",
  "profit=", show(profit), "\n"
];