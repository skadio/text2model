% Parameters
int: cal_cheesecake = 200;
int: sugar_cheesecake = 40;
int: cal_caramel = 250;
int: sugar_caramel = 50;

int: max_calories = 10000;
int: min_caramel_slices = 3;
int: cheesecake_ratio = 3; % cheesecake >= 3 * caramel

% Variables
var 0..(max_calories div cal_cheesecake): x_cheesecake;
var min_caramel_slices..(max_calories div cal_caramel): x_caramel;

% Constraints
constraint cal_cheesecake * x_cheesecake + cal_caramel * x_caramel <= max_calories;
constraint x_cheesecake >= cheesecake_ratio * x_caramel;

% Objective
solve maximize sugar_cheesecake * x_cheesecake + sugar_caramel * x_caramel;