int: total_budget = 100000;
int: telecom_max = 70000;

float: r_telecom = 0.03;
float: r_health = 0.01;

var 0.0..int2float(telecom_max): telecom;
var 0.0..int2float(total_budget): healthcare;

constraint telecom + healthcare <= int2float(total_budget);
constraint telecom >= 3.0 * healthcare;

var float: profit = r_telecom * telecom + r_health * healthcare;

solve maximize profit;

output [
  "Telecom investment: $", show(telecom), "\n",
  "Healthcare investment: $", show(healthcare), "\n",
  "Total invested: $", show(telecom + healthcare), "\n",
  "Profit: $", show(profit), "\n"
];