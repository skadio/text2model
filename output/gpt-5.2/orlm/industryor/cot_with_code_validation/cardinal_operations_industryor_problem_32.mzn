% Inheritance split between two sons: minimize difference in total value.

% Parameters
int: n = 13;
set of int: ITEMS = 1..n;

array[ITEMS] of int: value = [
  25000,  % painting by Caillebotte
   5000,  % bust of Diocletian
  20000,  % Yuan dynasty Chinese vase
  40000,  % 911 Porsche
  12000,  % diamond 1
  12000,  % diamond 2
  12000,  % diamond 3
   3000,  % Louis XV sofa
   3000,  % Jack Russell dog 1
   3000,  % Jack Russell dog 2
  10000,  % sculpture from 200 AD
  15000,  % sailing boat
  13000   % Cavour furniture
];

int: dog1 = 9;
int: dog2 = 10;

int: total_value = sum(i in ITEMS)(value[i]);

% Variables
array[ITEMS] of var 0..1: x; % x[i]=1 if item i goes to son 1, else to son 2

var 0..total_value: sum1;
var 0..total_value: sum2;
var 0..total_value: abs_diff;

% Constraints
constraint sum1 = sum(i in ITEMS)(value[i] * x[i]);
constraint sum2 = total_value - sum1;

% Dogs must not be separated
constraint x[dog1] = x[dog2];

% Absolute difference
constraint abs_diff >= sum1 - sum2;
constraint abs_diff >= sum2 - sum1;

% Objective
solve minimize abs_diff;

output [
  "sum1 = ", show(sum1), "\n",
  "sum2 = ", show(sum2), "\n",
  "abs_diff = ", show(abs_diff), "\n",
  "son1 items = ", show([i | i in ITEMS where fix(x[i]) = 1]), "\n",
  "son2 items = ", show([i | i in ITEMS where fix(x[i]) = 0]), "\n"
];