% International Wool Company - Sheep feed mix (min cost)
% All data embedded. Costs in cents, amounts per pound.

int: G = 3;
int: N = 4;

set of int: Grains = 1..G;
set of int: Nutrients = 1..N;

% Nutrient amounts per pound for each grain (scaled by 2 to avoid decimals due to 2.5)
% Nutrient order: A=1, B=2, C=3, D=4
array[Grains, Nutrients] of int: amt2 = array2d(Grains, Nutrients, [
  40, 20, 100, 12,   % Grain 1: (20,10,50,6) * 2
  60, 20,  60,  5,   % Grain 2: (30,10,30,2.5) * 2
 140,  0,   0, 20    % Grain 3: (70,0,0,10) * 2
]);

% Minimum requirements (also scaled by 2)
array[Nutrients] of int: req2 = [220, 36, 180, 28];

% Costs per pound in cents (objective)
array[Grains] of int: cost = [41, 36, 96];

% Decision variables: pounds of each grain (allow fractional pounds; scaled by 2 -> half-pound units)
int: SCALE = 2;
array[Grains] of var 0..2000: x;  % x[g] = number of half-pound units of grain g

% Nutrient constraints
constraint forall(n in Nutrients)(
  sum(g in Grains)( amt2[g,n] * x[g] ) >= req2[n] * SCALE
);

% Objective: minimize total cost (in cents)
var int: total_cost = sum(g in Grains)( cost[g] * x[g] ) div SCALE;

solve minimize total_cost;

output [
  "Minimum cost (cents) = ", show(total_cost), "\n",
  "Grain 1 (lb) = ", show(fix(x[1]) / 2.0), "\n",
  "Grain 2 (lb) = ", show(fix(x[2]) / 2.0), "\n",
  "Grain 3 (lb) = ", show(fix(x[3]) / 2.0), "\n"
];