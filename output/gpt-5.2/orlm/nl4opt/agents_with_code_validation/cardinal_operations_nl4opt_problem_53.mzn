% Ayse fertilizer mix - linear program
% Use MIP with scaled integers to avoid float issues in Gecode.

int: scale = 2; % scale to represent 0.5 kg steps exactly

% Costs per kg (scaled by scale so objective stays integer)
int: cost_C = 2 * scale; % $2/kg
int: cost_Y = 3 * scale; % $3/kg

% Minimum required nutrients
int: min_nitrous_oxide = 5;
int: min_vitamin_mix   = 8;

% Nutrient content per kg
% C: 1.5 NO, 3 Vit  -> per 0.5 kg: 0.75 NO, 1.5 Vit  (avoid fractions via integer constraints below)
% Y: 5 NO,   1 Vit

% Decision variables: amounts in half-kilograms (nonnegative integers)
var 0..1000: xC; % xC = 2 * kg_C
var 0..1000: xY; % xY = 2 * kg_Y

% Constraints (multiply to clear denominators)
% Nitrous: 1.5*kg_C + 5*kg_Y >= 5
% With xC=2*kg_C, xY=2*kg_Y:
% (3/4)*xC + (5/2)*xY >= 5  -> multiply by 4: 3*xC + 10*xY >= 20
constraint 3 * xC + 10 * xY >= 20;

% Vitamin: 3*kg_C + 1*kg_Y >= 8
% -> (3/2)*xC + (1/2)*xY >= 8 -> multiply by 2: 3*xC + 1*xY >= 16
constraint 3 * xC + xY >= 16;

% Objective: minimize total cost
% cost = 2*kg_C + 3*kg_Y = (2*xC + 3*xY)/2
% Minimizing numerator is equivalent
solve minimize cost_C * xC + cost_Y * xY;

output [
  "kg_C = ", show(xC / 2.0), "\n",
  "kg_Y = ", show(xY / 2.0), "\n",
  "min_cost = ", show((2 * xC + 3 * xY) / 2.0), "\n"
];