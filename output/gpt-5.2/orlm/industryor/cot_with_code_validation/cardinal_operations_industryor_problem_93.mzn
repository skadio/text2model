% Blending + tiered purchasing (all data embedded)
% Objective type: minimization (minimize total cost minus revenue)

% Parameters
int: invA = 500;          % tons of crude A inventory
int: invB = 1000;         % tons of crude B inventory
int: maxBuyA = 1500;      % max tons of crude A purchasable

int: priceI  = 4800;      % yuan/ton selling price gasoline I
int: priceII = 5600;      % yuan/ton selling price gasoline II

int: p1cap = 500;         % tier 1 cap (tons)
int: p2cap = 1000;        % cumulative cap tier 2 (tons)
int: p3cap = 1500;        % cumulative cap tier 3 (tons)

int: c1 = 10000;          % yuan/ton for first 500 tons
int: c2 = 8000;           % yuan/ton for next up to 1000 cumulative
int: c3 = 6000;           % yuan/ton for above 1000 up to 1500

% Variables (all integer tons to keep it fast and linear)
var 0..maxBuyA: buyA;

var 0..p1cap: buyA1;
var 0..(p2cap - p1cap): buyA2;
var 0..(p3cap - p2cap): buyA3;

var 0..(invA + maxBuyA): aI;
var 0..(invA + maxBuyA): aII;
var 0..invB: bI;
var 0..invB: bII;

var 0..(invA + maxBuyA + invB): xI;
var 0..(invA + maxBuyA + invB): xII;

var int: net_cost; % cost - revenue (minimize)

% Constraints
constraint buyA = buyA1 + buyA2 + buyA3;

constraint xI  = aI  + bI;
constraint xII = aII + bII;

constraint aI + aII <= invA + buyA;
constraint bI + bII <= invB;

% Minimum proportion constraints (avoid division; all integer linear)
% aI / xI >= 0.50  <=> 2*aI >= xI
% aII / xII >= 0.60 <=> 10*aII >= 6*xII
constraint 2 * aI >= xI;
constraint 10 * aII >= 6 * xII;

% Objective: minimize purchasing cost minus sales revenue
constraint net_cost =
    (c1 * buyA1 + c2 * buyA2 + c3 * buyA3)
  - (priceI * xI + priceII * xII);

solve minimize net_cost;

output [
  "buyA=", show(buyA), " (tier1=", show(buyA1), ", tier2=", show(buyA2), ", tier3=", show(buyA3), ")\n",
  "xI=", show(xI), " (aI=", show(aI), ", bI=", show(bI), ")\n",
  "xII=", show(xII), " (aII=", show(aII), ", bII=", show(bII), ")\n",
  "net_cost=", show(net_cost), "\n"
];