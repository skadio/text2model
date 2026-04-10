% Parameters
int: cal_cheesecake = 200;
int: sugar_cheesecake = 40;
int: cal_caramel = 250;
int: sugar_caramel = 50;

int: max_calories = 10000;
int: min_caramel_slices = 3;
int: cheesecake_ratio = 3; % cheesecake_slices >= 3 * caramel_slices

% Variables
var 0..(max_calories div cal_cheesecake): cheesecake_slices;
var min_caramel_slices..(max_calories div cal_caramel): caramel_slices;

% Constraints
constraint
  cal_cheesecake * cheesecake_slices + cal_caramel * caramel_slices <= max_calories;

constraint
  cheesecake_slices >= cheesecake_ratio * caramel_slices;

% Objective
solve maximize sugar_cheesecake * cheesecake_slices + sugar_caramel * caramel_slices;