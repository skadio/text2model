% Parameters (with values embedded)
int: cal_cheesecake = 200;
int: sugar_cheesecake = 40;
int: cal_caramel = 250;
int: sugar_caramel = 50;

int: max_calories = 10000;
int: min_caramel_slices = 3;

% Variables
var 0..(max_calories div cal_cheesecake): x_cheesecake; % slices of cheesecake
var 0..(max_calories div cal_caramel): x_caramel;       % slices of caramel cake

% Constraints
constraint x_caramel >= min_caramel_slices;
constraint x_cheesecake >= 3 * x_caramel;

constraint cal_cheesecake * x_cheesecake + cal_caramel * x_caramel <= max_calories;

% Objective
solve maximize sugar_cheesecake * x_cheesecake + sugar_caramel * x_caramel;