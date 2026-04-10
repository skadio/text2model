% Parameters
int: itemsA = 30;
int: itemsB = 50;
int: kwhA = 100;
int: kwhB = 120;

int: minItems = 1000;
int: maxKwh = 3000;

float: maxFracB = 0.30;
int: minA = 5;

% Variables
var 0..1000: A;
var 0..1000: B;

% Constraints
constraint A >= minA;

constraint itemsA * A + itemsB * B >= minItems;

constraint kwhA * A + kwhB * B <= maxKwh;

% At most 30% of machines are type B: B <= 0.30*(A+B) -> 0.70*B <= 0.30*A -> 7B <= 3A
constraint 7 * B <= 3 * A;

% Objective
solve minimize A + B;