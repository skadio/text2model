int: invA = 500;
int: invB = 1000;
int: maxBuyA = 1500;

int: priceI = 4800;
int: priceII = 5600;

int: tier1_cap = 500;
int: tier2_cap = 500;
int: tier3_cap = 500;

int: cost1 = 10000;
int: cost2 = 8000;
int: cost3 = 6000;

var 0..tier1_cap: buy1;
var 0..tier2_cap: buy2;
var 0..tier3_cap: buy3;
var 0..maxBuyA: buyA;

var 0..(invA + maxBuyA): aI;
var 0..(invA + maxBuyA): aII;
var 0..invB: bI;
var 0..invB: bII;

var 0..(invA + maxBuyA + invB): xI;
var 0..(invA + maxBuyA + invB): xII;

constraint buyA = buy1 + buy2 + buy3;

constraint xI = aI + bI;
constraint xII = aII + bII;

constraint aI + aII <= invA + buyA;
constraint bI + bII <= invB;

constraint 2 * aI >= xI;
constraint 10 * aII >= 6 * xII;

solve minimize (cost1 * buy1 + cost2 * buy2 + cost3 * buy3) - (priceI * xI + priceII * xII);

output [
  "buyA=", show(buyA), " (buy1=", show(buy1), ", buy2=", show(buy2), ", buy3=", show(buy3), ")\n",
  "Type I:  xI=", show(xI), "  (aI=", show(aI), ", bI=", show(bI), ")\n",
  "Type II: xII=", show(xII), "  (aII=", show(aII), ", bII=", show(bII), ")\n",
  "purchase_cost=", show(cost1 * buy1 + cost2 * buy2 + cost3 * buy3), "\n",
  "revenue=", show(priceI * xI + priceII * xII), "\n",
  "net_cost(purchase - revenue)=", show((cost1 * buy1 + cost2 * buy2 + cost3 * buy3) - (priceI * xI + priceII * xII)), "\n"
];