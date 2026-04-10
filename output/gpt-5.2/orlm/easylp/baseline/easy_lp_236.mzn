int: max_acres = 10000;

var 0..max_acres: wheat;
var 0..max_acres: corn;
var 0..max_acres: soy;

constraint wheat + corn <= 200;
constraint 2 * wheat + soy >= 150;
constraint abs(corn - soy) <= 100;

var int: total_cost = 20 * wheat + 30 * corn + 10 * soy;

solve minimize total_cost;

output [
  "wheat=", show(wheat), " acres\n",
  "corn=", show(corn), " acres\n",
  "soy=", show(soy), " acres\n",
  "total_cost=$", show(total_cost), "\n"
];