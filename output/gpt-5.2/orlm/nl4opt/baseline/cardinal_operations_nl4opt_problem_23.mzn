int: kids_min = 150;

int: van_cap = 6;
int: van_poll = 7;

int: bus_cap = 10;
int: bus_poll = 10;

int: bus_max = 10;

var 0..1000: vans;
var 0..bus_max: minibuses;

constraint van_cap * vans + bus_cap * minibuses >= kids_min;
constraint vans > minibuses;

var int: total_pollution = van_poll * vans + bus_poll * minibuses;

solve minimize total_pollution;

output [
  "vans=", show(vans), "\n",
  "minibuses=", show(minibuses), "\n",
  "total_pollution=", show(total_pollution), "\n",
  "total_capacity=", show(van_cap*vans + bus_cap*minibuses), "\n"
];