int: mint_avail = 120;
int: active_avail = 100;
int: tar_limit = 50;

int: mint1 = 10;
int: active1 = 20;
int: foam1 = 25;
int: tar1 = 5;

int: mint2 = 12;
int: active2 = 15;
int: foam2 = 18;
int: tar2 = 3;

var 0..1000: d1;
var 0..1000: d2;

constraint mint1 * d1 + mint2 * d2 <= mint_avail;
constraint active1 * d1 + active2 * d2 <= active_avail;
constraint tar1 * d1 + tar2 * d2 <= tar_limit;

var int: total_foam = foam1 * d1 + foam2 * d2;

solve maximize total_foam;

output [
  "demonstration_1=", show(d1), "\n",
  "demonstration_2=", show(d2), "\n",
  "total_minty_foam=", show(total_foam), "\n"
];