int: F = 5;

array[1..F] of float: price_per_100lb = [21.75, 23.50, 22.00, 19.50, 18.50];

array[1..F] of float: Ni = [10.0, 8.0, 12.0, 10.0, 15.0];
array[1..F] of float: Ph = [8.0, 11.0, 7.0, 10.0, 10.0];
array[1..F] of float: Po = [12.0, 15.0, 12.0, 10.0, 6.0];

float: Ni_lo = 10.0;
float: Ni_hi = 10.5;
float: Ph_lo = 8.0;
float: Ph_hi = 8.5;
float: Po_lo = 12.0;
float: Po_hi = 12.5;

array[1..F] of var 0.0..1.0: x;
var 0.0..1000.0: cost_per_lb;

constraint sum(i in 1..F)(x[i]) = 1.0;

var float: Ni_mix = sum(i in 1..F)(Ni[i] * x[i]);
var float: Ph_mix = sum(i in 1..F)(Ph[i] * x[i]);
var float: Po_mix = sum(i in 1..F)(Po[i] * x[i]);

constraint Ni_lo <= Ni_mix /\ Ni_mix <= Ni_hi;
constraint Ph_lo <= Ph_mix /\ Ph_mix <= Ph_hi;
constraint Po_lo <= Po_mix /\ Po_mix <= Po_hi;

constraint cost_per_lb = (sum(i in 1..F)(price_per_100lb[i] * x[i])) / 100.0;

solve minimize cost_per_lb;

output [
  "cost_per_lb=", show(cost_per_lb), "\n",
  "x=", show(x), "\n",
  "Ni_mix=", show(Ni_mix), " Ph_mix=", show(Ph_mix), " Po_mix=", show(Po_mix), "\n"
];