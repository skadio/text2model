% Blending and purchasing crude oils A and B to produce gasoline types I and II
% Maximize profit = revenue from gasoline - cost of purchased crude A
% All data embedded.

int: invA = 500;          % tons of crude A in inventory
int: invB = 1000;         % tons of crude B in inventory
int: maxPurchaseA = 1500; % max tons of crude A purchasable

int: priceI = 4800;       % yuan/ton
int: priceII = 5600;      % yuan/ton

% Minimum proportion of A in each gasoline type:
% Type I: A/(A+B) >= 0.50  => A >= B
% Type II: A/(A+B) >= 0.60 => A >= 1.5 B => 2A >= 3B

% Decision variables: tons of A and B used in each gasoline product
var 0..(invA + maxPurchaseA): aI;
var 0..(invA + maxPurchaseA): aII;
var 0..invB: bI;
var 0..invB: bII;

% Purchased crude A split into price tiers
var 0..500:  buy1;   % first 0..500 at 10000
var 0..500:  buy2;   % next 0..500 at 8000
var 0..500:  buy3;   % next 0..500 at 6000

var 0..maxPurchaseA: buyA;

constraint buyA = buy1 + buy2 + buy3;

% Resource availability
constraint aI + aII <= invA + buyA;
constraint bI + bII <= invB;

% Blend constraints (min proportions of A)
constraint aI >= bI;           % Type I: A >= B
constraint 2 * aII >= 3 * bII; % Type II: 2A >= 3B

% Objective: maximize profit
var int: revenue = priceI * (aI + bI) + priceII * (aII + bII);
var int: purchaseCost = 10000 * buy1 + 8000 * buy2 + 6000 * buy3;
var int: profit = revenue - purchaseCost;

solve maximize profit;

output [
  "aI=", show(aI), " t\n",
  "bI=", show(bI), " t\n",
  "aII=", show(aII), " t\n",
  "bII=", show(bII), " t\n",
  "Gasoline I total=", show(aI + bI), " t (A%=", show( if aI + bI > 0 then (100 * aI) div (aI + bI) else 0 endif ), ")\n",
  "Gasoline II total=", show(aII + bII), " t (A%=", show( if aII + bII > 0 then (100 * aII) div (aII + bII) else 0 endif ), ")\n",
  "buyA=", show(buyA), " t  [buy1=", show(buy1), ", buy2=", show(buy2), ", buy3=", show(buy3), "]\n",
  "Revenue=", show(revenue), " yuan\n",
  "PurchaseCost=", show(purchaseCost), " yuan\n",
  "Profit=", show(profit), " yuan\n"
];