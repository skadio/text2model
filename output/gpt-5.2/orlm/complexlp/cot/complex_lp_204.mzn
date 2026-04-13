% Parameters (with values embedded)
int: F = 5;
set of int: Fert = 1..F;

array[Fert] of int: Ni = [10, 8, 12, 10, 15];   % nitrogen percentages
array[Fert] of int: Ph = [8, 11, 7, 10, 10];    % phosphorus percentages
array[Fert] of int: Po = [12, 15, 12, 10, 6];   % potash percentages

array[Fert] of int: pricePer100 = [2175, 2350, 2200, 1950, 1850]; % cents per 100 lb

% Targets and tolerances (use half-percent => multiply all % by 2 to avoid fractions)
int: Ni_min2 = 20; int: Ni_max2 = 21;   % 10.0% .. 10.5%
int: Ph_min2 = 16; int: Ph_max2 = 17;   %  8.0% ..  8.5%
int: Po_min2 = 24; int: Po_max2 = 25;   % 12.0% .. 12.5%

% Variables
% Let x[f] be pounds of fertilizer f used in a 100-lb blend
array[Fert] of var 0..100: x;

% Total cost in cents for the 100-lb blend
var 0..5000: totalCostCents;

% Constraints
constraint sum(f in Fert)(x[f]) = 100;

% Define total cost (pricePer100 is cents per 100 lb, so cost contribution is pricePer100 * x / 100)
constraint totalCostCents * 100 = sum(f in Fert)(pricePer100[f] * x[f]);

% Chemical composition constraints on the 100-lb blend
% We enforce: min <= average% <= max, using scaled-by-2 percentages and avoiding division:
% sum(2*percent_f * x_f) between (min2*100) and (max2*100)
constraint sum(f in Fert)( (2 * Ni[f]) * x[f] ) >= Ni_min2 * 100;
constraint sum(f in Fert)( (2 * Ni[f]) * x[f] ) <= Ni_max2 * 100;

constraint sum(f in Fert)( (2 * Ph[f]) * x[f] ) >= Ph_min2 * 100;
constraint sum(f in Fert)( (2 * Ph[f]) * x[f] ) <= Ph_max2 * 100;

constraint sum(f in Fert)( (2 * Po[f]) * x[f] ) >= Po_min2 * 100;
constraint sum(f in Fert)( (2 * Po[f]) * x[f] ) <= Po_max2 * 100;

% Objective
% Minimize cost per pound; with a 100-lb blend this is equivalent to minimizing totalCostCents
solve minimize totalCostCents;