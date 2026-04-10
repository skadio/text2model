% Printer production profit maximization

int: max_color = 20;
int: max_bw = 30;
int: max_total = 35;

int: profit_color = 200;
int: profit_bw = 70;

var 0..max_color: color;
var 0..max_bw: bw;

constraint color + bw <= max_total;

var int: total_profit = profit_color * color + profit_bw * bw;

solve maximize total_profit;

output [
  "color_printers = ", show(color), "\n",
  "bw_printers = ", show(bw), "\n",
  "total_profit = $", show(total_profit), "\n"
];