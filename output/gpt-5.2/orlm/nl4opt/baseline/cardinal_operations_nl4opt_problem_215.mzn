int: cal_cheesecake = 200;
int: sugar_cheesecake = 40;
int: cal_caramel = 250;
int: sugar_caramel = 50;

int: max_calories = 10000;

var int: x; % slices of cheesecake
var int: y; % slices of caramel cake

constraint x >= 0 /\ y >= 0;
constraint x >= 3 * y;
constraint y >= 3;
constraint cal_cheesecake * x + cal_caramel * y <= max_calories;

var int: total_sugar = sugar_cheesecake * x + sugar_caramel * y;

solve maximize total_sugar;

output [
  "cheesecake_slices=", show(x), "\n",
  "caramel_slices=", show(y), "\n",
  "total_sugar_grams=", show(total_sugar), "\n",
  "total_calories=", show(cal_cheesecake * x + cal_caramel * y), "\n"
];