% Cake eating optimization (maximize sugar subject to calorie limit and preferences)

% Data (embedded from problem description)
int: cal_cheesecake = 200;
int: sug_cheesecake = 40;

int: cal_caramel = 250;
int: sug_caramel = 50;

int: max_calories = 10000;

% Decision variables: number of slices
var 0..max_calories div cal_cheesecake: cheesecake;
var 0..max_calories div cal_caramel: caramel;

% Constraints
constraint cal_cheesecake * cheesecake + cal_caramel * caramel <= max_calories;
constraint cheesecake >= 3 * caramel;
constraint caramel >= 3;

% Objective: maximize total sugar
var int: total_sugar = sug_cheesecake * cheesecake + sug_caramel * caramel;
solve maximize total_sugar;

output [
  "Cheesecake slices = ", show(cheesecake), "\n",
  "Caramel slices    = ", show(caramel), "\n",
  "Total calories    = ", show(cal_cheesecake * cheesecake + cal_caramel * caramel), "\n",
  "Total sugar (g)   = ", show(total_sugar), "\n"
];