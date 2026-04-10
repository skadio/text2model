% Inheritance partitioning between two sons: minimize difference in total value

int: N = 13;
set of int: ITEMS = 1..N;

array[ITEMS] of int: value = [
  25000,  % painting by Caillebotte
   5000,  % bust of Diocletian
  20000,  % Yuan dynasty Chinese vase
  40000,  % 911 Porsche
  12000,  % diamond 1
  12000,  % diamond 2
  12000,  % diamond 3
   3000,  % Louis XV sofa
   3000,  % dog 1 (paired)
   3000,  % dog 2 (paired)
  10000,  % sculpture from 200 AD
  15000,  % sailing boat
  13000   % Cavour furniture
];

int: dog1 = 9;
int: dog2 = 10;

int: total_value = sum(i in ITEMS)(value[i]);

% Decision variables: x[i]=1 if item i goes to son A, else to son B
array[ITEMS] of var 0..1: x;

var 0..total_value: sumA = sum(i in ITEMS)(value[i] * x[i]);
var 0..total_value: sumB = total_value - sumA;

% 'diff' is a reserved keyword in MiniZinc; use a different identifier
var 0..total_value: absDiff;

constraint absDiff >= sumA - sumB;
constraint absDiff >= sumB - sumA;

% Dogs must not be separated
constraint x[dog1] = x[dog2];

solve minimize absDiff;

output [
  "sumA = ", show(sumA), "\n",
  "sumB = ", show(sumB), "\n",
  "absDiff = ", show(absDiff), "\n",
  "Items to son A (indices): ", show([i | i in ITEMS where fix(x[i]) = 1]), "\n"
];