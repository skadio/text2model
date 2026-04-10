int: train_capacity = 120;
int: tram_capacity  = 30;
int: demand         = 600;

var 0..ceil(demand div train_capacity + 10): trains;
var 0..ceil(demand div tram_capacity + 10): trams;

constraint trams >= 2 * trains;
constraint train_capacity * trains + tram_capacity * trams >= demand;

solve minimize trains + trams;

output [
  "trains=", show(trains), "\n",
  "trams=", show(trams), "\n",
  "total_units=", show(trains + trams), "\n",
  "capacity=", show(train_capacity * trains + tram_capacity * trams), "\n"
];