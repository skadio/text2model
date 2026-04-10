% Parameters
int: items_needed = 1000;
int: energy_available = 3000;

int: itemA = 30;
int: itemB = 50;

int: energyA = 100;
int: energyB = 120;

float: max_frac_B = 0.30;
int: min_A = 5;

% Variables
var int: xA; % number of machines of type A
var int: xB; % number of machines of type B

% Constraints
constraint xA >= 0;
constraint xB >= 0;

constraint xA >= min_A;

constraint itemA * xA + itemB * xB >= items_needed;

constraint energyA * xA + energyB * xB <= energy_available;

% At most 30% of machines are type B: xB <= 0.30*(xA+xB)
% Avoid floats by multiplying: 10*xB <= 3*(xA+xB) -> 7*xB <= 3*xA
constraint 7 * xB <= 3 * xA;

% Objective
solve minimize xA + xB;