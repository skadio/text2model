% Solar Oil blending problem: maximize profit from regular and premium gasoline

int: nRaw = 4;
int: nProd = 2;

set of int: RAW = 1..nRaw;
set of int: PROD = 1..nProd;

% Raw gas data
array[RAW] of float: rawOctane = [86.0, 88.0, 92.0, 96.0];
array[RAW] of float: rawAvail  = [20000.0, 15000.0, 15000.0, 10000.0];
array[RAW] of float: rawCost   = [17.0, 18.0, 20.5, 23.0];

% Product data: 1=Regular, 2=Premium
array[PROD] of float: minOctane = [89.0, 93.0];
array[PROD] of float: sellPrice = [19.5, 22.0];
array[PROD] of float: maxDemand = [35000.0, 23000.0];

% Decision variables: barrels of raw i blended into product p
array[RAW, PROD] of var float: x;   % x[i,p] >= 0

% Amount produced of each product
array[PROD] of var float: prodVol = [ sum(i in RAW)(x[i,p]) | p in PROD ];

% Availability constraints
constraint forall(i in RAW)(
  sum(p in PROD)(x[i,p]) <= rawAvail[i]
);

% Demand constraints
constraint forall(p in PROD)(
  prodVol[p] <= maxDemand[p]
);

% Octane constraints (linearized): sum(oct_i * x_i) >= minOctane * sum(x_i)
constraint forall(p in PROD)(
  sum(i in RAW)(rawOctane[i] * x[i,p]) >= minOctane[p] * prodVol[p]
);

% Nonnegativity
constraint forall(i in RAW, p in PROD)( x[i,p] >= 0.0 );

% Objective: maximize profit = revenue - raw material costs
var float: revenue = sum(p in PROD)(sellPrice[p] * prodVol[p]);
var float: cost    = sum(i in RAW, p in PROD)(rawCost[i] * x[i,p]);
var float: profit  = revenue - cost;

solve maximize profit;

output [
  "Max profit = $", show(profit), "\n",
  "Regular volume = ", show(prodVol[1]), " barrels\n",
  "Premium volume = ", show(prodVol[2]), " barrels\n",
  "\nBlend (barrels of raw i into product p):\n",
  concat([ "Raw " ++ show(i) ++ " -> Regular: " ++ show(x[i,1]) ++
           ", Premium: " ++ show(x[i,2]) ++ "\n" | i in RAW ])
];