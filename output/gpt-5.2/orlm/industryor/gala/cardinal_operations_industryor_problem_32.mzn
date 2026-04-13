include "globals.mzn";

% Inheritance partitioning between two sons
% Goal: minimize absolute difference in total value.

int: n = 13;

set of int: ITEMS = 1..n;

array[ITEMS] of int: value = [
  25000,  % 1  painting
  5000,   % 2  bust
  20000,  % 3  vase
  40000,  % 4  Porsche
  12000,  % 5  diamond 1
  12000,  % 6  diamond 2
  12000,  % 7  diamond 3
  3000,   % 8  Louis XV sofa
  3000,   % 9  dog 1
  3000,   % 10 dog 2
  10000,  % 11 sculpture (200 AD)
  15000,  % 12 sailing boat
  10000,  % 13 Harley motorcycle
  % Note: "Cavour furniture: 13000" must be included, so we add it as item 14
];

% Oops: the list above has 13 entries; but the description has 14 distinct items
% (11 base items + 3 diamonds + 2 dogs = 16? let's count precisely)
% Painting(1), Bust(2), Vase(3), Porsche(4), Diamonds(3 items:5-7),
% Sofa(8), Dogs(2 items:9-10), Sculpture(11), Boat(12), Harley(13),
% Cavour furniture(14). Total = 14.
% Therefore, correct n and arrays below accordingly.

% --- Corrected data ---
int: n2 = 14;
set of int: I = 1..n2;

array[I] of int: v = [
  25000,  % 1  painting by Caillebotte
  5000,   % 2  bust of Diocletian
  20000,  % 3  Yuan dynasty vase
  40000,  % 4  911 Porsche
  12000,  % 5  diamond 1
  12000,  % 6  diamond 2
  12000,  % 7  diamond 3
  3000,   % 8  Louis XV sofa
  3000,   % 9  Jack Russell dog 1
  3000,   % 10 Jack Russell dog 2
  10000,  % 11 sculpture from 200 AD
  15000,  % 12 sailing boat
  10000,  % 13 Harley Davidson motorcycle
  13000   % 14 Cavour furniture
];

array[I] of string: name = [
  "Painting (Caillebotte)",
  "Bust (Diocletian)",
  "Chinese vase (Yuan dynasty)",
  "911 Porsche",
  "Diamond 1",
  "Diamond 2",
  "Diamond 3",
  "Louis XV sofa",
  "Racing dog 1",
  "Racing dog 2",
  "Sculpture (200 AD)",
  "Sailing boat",
  "Harley Davidson motorcycle",
  "Cavour furniture"
];

% Decision: assign each item to Son 1 (1) or Son 2 (2)
array[I] of var 1..2: who;

% Dogs must not be separated
constraint who[9] = who[10];

% Totals and objective
var 0..sum(i in I)(v[i]): total1 = sum(i in I)(v[i] * bool2int(who[i] = 1));
var 0..sum(i in I)(v[i]): total2 = sum(i in I)(v[i] * bool2int(who[i] = 2));

var 0..sum(i in I)(v[i]): diff;
constraint diff = abs(total1 - total2);

solve minimize diff;

output [
  "Total Son 1 = ", show(total1), "\n",
  "Total Son 2 = ", show(total2), "\n",
  "Difference  = ", show(diff), "\n\n",
  "Assignments:\n"
] ++
[
  if fix(who[i]) = 1 then
    "  Son 1: " ++ name[i] ++ " (" ++ show(v[i]) ++ ")\n"
  else
    "  Son 2: " ++ name[i] ++ " (" ++ show(v[i]) ++ ")\n"
  endif
  | i in I
];