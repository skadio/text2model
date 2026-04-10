% Parameters (with values embedded)
int: NOrders = 3;
set of int: O = 1..NOrders;

int: NStock = 2;
set of int: S = 1..NStock;

% Use centimeters to avoid decimals:
% Order widths: [0.5, 0.7, 0.9] m -> [50, 70, 90] cm
array[O] of int: orderWidth = [50, 70, 90];
% Order required lengths (meters)
array[O] of int: orderLength = [1000, 3000, 2000];

% Stock roll widths: [1, 2] m -> [100, 200] cm
array[S] of int: stockWidth = [100, 200];

% Max number of strips of any order width that can fit in a stock width
int: maxStrips = max([stockWidth[s] div min(orderWidth) | s in S]); % = 4 here

% Variables
% x[s,o] = number of strips of order o cut side-by-side from stock width s (per cutting pattern of width s)
array[S,O] of var 0..maxStrips: x;

% Total length (in meters) of stock roll of width s that is processed using pattern x[s,*]
array[S] of var 0..max(orderLength): L;

% Constraints
% Feasibility: total cut width cannot exceed stock width
constraint forall(s in S)(
  sum(o in O)(x[s,o] * orderWidth[o]) <= stockWidth[s]
);

% Demand satisfaction (length can be spliced; widths are produced continuously along length L[s])
constraint forall(o in O)(
  sum(s in S)(x[s,o] * L[s]) >= orderLength[o]
);

% Objective
% Waste area (in m^2):
% For each stock width s, processed area = stockWidth[s](cm)/100 * L[s](m)
% Useful area = sum_o (orderWidth[o](cm)/100 * (x[s,o]*L[s]))
% Waste = processed - useful = ( (stockWidth[s] - sum_o x[s,o]*orderWidth[o]) / 100 ) * L[s]
var int: waste_scaled = sum(s in S)(
  (stockWidth[s] - sum(o in O)(x[s,o] * orderWidth[o])) * L[s]
); % units: (cm * m)

solve minimize waste_scaled;