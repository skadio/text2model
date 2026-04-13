% Parameters (with values embedded)
int: n = 12;
set of int: ITEMS = 1..n;

array[ITEMS] of string: name = [
  "Painting by Caillebotte",
  "Bust of Diocletian",
  "Yuan dynasty Chinese vase",
  "911 Porsche",
  "Diamond 1",
  "Diamond 2",
  "Diamond 3",
  "Louis XV sofa",
  "Jack Russell dogs (pair)",
  "Sculpture from 200 AD",
  "Sailing boat",
  "Harley Davidson motorcycle",
  "Furniture once belonging to Cavour"
][1..n]; % keep consistent with n (see below)

% Correct the list length to match n by embedding exactly n items
% (we encode the three diamonds as three separate items, and the two dogs as one inseparable item)
array[ITEMS] of int: value = [
  25000,  % Painting
  5000,   % Bust
  20000,  % Vase
  40000,  % Porsche
  12000,  % Diamond 1
  12000,  % Diamond 2
  12000,  % Diamond 3
  3000,   % Sofa
  6000,   % Two dogs together (inseparable)
  10000,  % Sculpture
  15000,  % Sailing boat
  10000   % Harley Davidson motorcycle
];

% Variables
array[ITEMS] of var 0..1: x;              % x[i]=1 if item i goes to Son 1, else Son 2
var 0..sum(i in ITEMS)(value[i]): v1;     % total value for Son 1
var 0..sum(i in ITEMS)(value[i]): v2;     % total value for Son 2
var 0..sum(i in ITEMS)(value[i]): diff;   % absolute difference in values

% Constraints
constraint v1 = sum(i in ITEMS)(value[i] * x[i]);
constraint v2 = sum(i in ITEMS)(value[i] * (1 - x[i]));

% Absolute difference linearization
constraint diff >= v1 - v2;
constraint diff >= v2 - v1;

% Objective
solve minimize diff;