% Parameters (with values embedded)
int: itemsA = 30;
int: itemsB = 50;
int: kwhA = 100;
int: kwhB = 120;

int: minItems = 1000;
int: maxKwh = 3000;

float: maxFracB = 0.30;
int: minA = 5;

% Upper bounds from electricity limits
int: maxA = maxKwh div kwhA; % 3000/100 = 30
int: maxB = maxKwh div kwhB; % 3000/120 = 25

% Variables
var 0..maxA: A;
var 0..maxB: B;

% Constraints
constraint A >= minA;

constraint itemsA * A + itemsB * B >= minItems;

constraint kwhA * A + kwhB * B <= maxKwh;

% At most 30% of machines are type B: B <= 0.3*(A+B)  <=>  10B <= 3(A+B)  <=>  7B <= 3A
constraint 7 * B <= 3 * A;

% Objective
solve minimize A + B;