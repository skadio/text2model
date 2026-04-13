% Factory machines optimization (all data embedded)

% Decision variables: number of machines of each type
var int: A >= 0;
var int: B >= 0;

% Data
int: itemsA = 30;
int: itemsB = 50;
int: kwhA   = 100;
int: kwhB   = 120;

int: minItems = 1000;
int: maxKwh   = 3000;

int: minA = 5;

% Constraints
constraint itemsA * A + itemsB * B >= minItems;
constraint kwhA * A + kwhB * B <= maxKwh;

% At most 30% of machines are type B: B <= 0.3*(A+B)  =>  7B <= 3A
constraint 7 * B <= 3 * A;

constraint A >= minA;

% Objective: minimize total number of machines
solve minimize A + B;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Total machines = ", show(A + B), "\n",
  "Items produced = ", show(itemsA*A + itemsB*B), "\n",
  "Energy used (kWh) = ", show(kwhA*A + kwhB*B), "\n"
];