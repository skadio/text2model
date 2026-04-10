% International Wool Company feed mix (LP) as an integer linear program in cents.
% Decision variables: pounds of each grain fed per day.

include "globals.mzn";

%----------------------------
% Data (embedded from description)
%----------------------------
int: G = 3;  % grains
int: N = 4;  % nutrients: A,B,C,D

set of int: Grains = 1..G;
set of int: Nuts = 1..N;

% Nutrient content per pound of grain (units/pound)
% rows: nutrients A,B,C,D ; cols: grains 1..3
array[Nuts, Grains] of float: nutr = array2d(Nuts, Grains,
[
  20.0, 30.0, 70.0,   % A
  10.0, 10.0,  0.0,   % B
  50.0, 30.0,  0.0,   % C
   6.0,  2.5, 10.0    % D
]);

% Minimum daily requirements
array[Nuts] of float: req = [110.0, 18.0, 90.0, 14.0];

% Cost in cents per pound
array[Grains] of int: cost = [41, 36, 96];

% Scale to avoid fractions: D has 2.5, multiply all nutrient constraints by 2
int: SCALE = 2;
array[Nuts, Grains] of int: nutrS =
  array2d(Nuts, Grains, [ round(nutr[n,g] * SCALE) | n in Nuts, g in Grains ]);
array[Nuts] of int: reqS = [ round(req[n] * SCALE) | n in Nuts ];

%----------------------------
% Variables
%----------------------------
% Pounds of each grain (allow half-pound increments by using integer "half-pounds")
% xh[g] = 2 * pounds(g)
array[Grains] of var 0..1000: xh;

var int: totalCost = sum(g in Grains)( cost[g] * xh[g] ) div SCALE;

%----------------------------
% Constraints: meet or exceed nutrient minimums
%----------------------------
constraint forall(n in Nuts)(
  sum(g in Grains)( nutrS[n,g] * xh[g] ) >= reqS[n] * SCALE
);

%----------------------------
% Objective
%----------------------------
solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Minimum cost (cents) = ", show(totalCost), "\n",
  "Half-pounds xh = ", show(xh), "\n",
  "Pounds = ", show([ float2int(xh[g]) / 2.0 | g in Grains ]), "\n"
];