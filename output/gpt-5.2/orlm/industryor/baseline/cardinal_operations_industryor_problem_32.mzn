% Inheritance partition between two sons: minimize difference in total value.

set of int: ITEMS = 1..12;

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
][1..12]; % keep length consistent with ITEMS

array[ITEMS] of int: value = [
  25000,
  5000,
  20000,
  40000,
  12000,
  12000,
  12000,
  3000,
  6000,   % dogs must not be separated -> treat as a single item worth 2*3000
  10000,
  15000,
  10000,
  13000
][1..12];

int: TOTAL = sum(i in ITEMS)(value[i]);

array[ITEMS] of var bool: in_son1; % true if item assigned to son 1, else son 2

var 0..TOTAL: sum1 = sum(i in ITEMS)(value[i] * bool2int(in_son1[i]));
var 0..TOTAL: sum2 = TOTAL - sum1;

var 0..TOTAL: diff = abs(sum1 - sum2);

solve minimize diff;

output [
  "Total value: ", show(TOTAL), "\n",
  "Son 1 total: ", show(sum1), "\n",
  "Son 2 total: ", show(sum2), "\n",
  "Difference:  ", show(diff), "\n\n",
  "Son 1 items:\n"
] ++
[
  if fix(in_son1[i]) then "  - " ++ name[i] ++ " ($" ++ show(value[i]) ++ ")\n" else "" endif
  | i in ITEMS
] ++
[
  "\nSon 2 items:\n"
] ++
[
  if not fix(in_son1[i]) then "  - " ++ name[i] ++ " ($" ++ show(value[i]) ++ ")\n" else "" endif
  | i in ITEMS
];