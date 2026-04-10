% Inheritance division between two sons
% Minimize the absolute difference in total value.

int: n = 11;
set of int: ITEMS = 1..n;

array[ITEMS] of string: item_name = [
  "Painting (Caillebotte)",
  "Bust (Diocletian)",
  "Chinese vase (Yuan dynasty)",
  "Porsche 911",
  "Diamonds (3x)",
  "Sofa (Louis XV)",
  "Racing dogs (pair, inseparable)",
  "Sculpture (200 AD)",
  "Sailing boat",
  "Harley Davidson motorcycle",
  "Cavour furniture"
];

array[ITEMS] of int: value = [
  25000,   % painting
  5000,    % bust
  20000,   % vase
  40000,   % porsche
  36000,   % 3 diamonds
  3000,    % sofa
  6000,    % 2 dogs inseparable
  10000,   % sculpture
  15000,   % boat
  10000,   % motorcycle
  13000    % cavour furniture
];

int: total_value = sum(i in ITEMS)(value[i]);

% x[i] = 1 if item i goes to Son 1, else to Son 2
array[ITEMS] of var 0..1: x;

var 0..total_value: value_son1;
var 0..total_value: value_son2;

% 'diff' is a reserved word in MiniZinc, so use another name
var 0..total_value: abs_diff;

constraint value_son1 = sum(i in ITEMS)(value[i] * x[i]);
constraint value_son2 = total_value - value_son1;

constraint abs_diff = abs(value_son1 - value_son2);

solve minimize abs_diff;

output [
  "Total value: ", show(total_value), "\n",
  "Son 1 value: ", show(value_son1), "\n",
  "Son 2 value: ", show(value_son2), "\n",
  "Absolute difference: ", show(abs_diff), "\n\n",
  "Items to Son 1:\n"
] ++
[
  if fix(x[i]) = 1 then "  - " ++ item_name[i] ++ " (" ++ show(value[i]) ++ ")\n" else "" endif
  | i in ITEMS
] ++
[
  "\nItems to Son 2:\n"
] ++
[
  if fix(x[i]) = 0 then "  - " ++ item_name[i] ++ " (" ++ show(value[i]) ++ ")\n" else "" endif
  | i in ITEMS
];