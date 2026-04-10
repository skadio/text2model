int: max_pills = 1000;

var 0..max_pills: x1; % number of Pill 1
var 0..max_pills: x2; % number of Pill 2

constraint 0.2*x1 + 0.6*x2 <= 6.0;  % pain medication limit
constraint 0.3*x1 + 0.2*x2 >= 3.0;  % anxiety medication requirement

var float: discharge = 0.3*x1 + 0.1*x2;

solve minimize discharge;

output [
  "Pill1=", show(x1), "\n",
  "Pill2=", show(x2), "\n",
  "pain=", show(0.2*x1 + 0.6*x2), "\n",
  "anxiety=", show(0.3*x1 + 0.2*x2), "\n",
  "discharge=", show(discharge), "\n"
];