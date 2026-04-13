int: n = 14;
set of int: ITEMS = 1..n;

array[ITEMS] of int: value = [
  25000,
   5000,
  20000,
  40000,
  12000,
  12000,
  12000,
   3000,
   3000,
   3000,
  10000,
  15000,
  10000,
  13000
];

int: total_value = sum(i in ITEMS)(value[i]);

array[ITEMS] of var 0..1: x;

var 0..total_value: sumA = sum(i in ITEMS)(value[i] * x[i]);
var 0..total_value: sumB = total_value - sumA;

var -total_value..total_value: d;
var 0..total_value: absd;

constraint x[9] = x[10];

constraint d = sumA - sumB;
constraint absd >= d;
constraint absd >= -d;

solve minimize absd;