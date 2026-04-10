% Parameters
int: calories_cheesecake = 200;      % calories per slice of cheesecake
int: sugar_cheesecake    = 40;       % grams of sugar per slice of cheesecake
int: calories_caramel    = 250;      % calories per slice of caramel cake
int: sugar_caramel       = 50;       % grams of sugar per slice of caramel cake

int: max_calories = 10000;           % maximum calories per day
int: min_caramel  = 3;               % minimum caramel slices required
int: cheesecake_to_caramel_ratio = 3; % must eat at least this many cheesecake per caramel

% Variables
var 0..(max_calories div calories_cheesecake): cheesecake_slices;  % number of cheesecake slices
var min_caramel..(max_calories div calories_caramel): caramel_slices; % number of caramel slices

% Upper bound: in the absolute best case sugar-per-slice is max(sugar_*),
% and max number of slices is bounded by min calories per slice.
var 0..((max_calories div min(calories_cheesecake, calories_caramel)) * max(sugar_cheesecake, sugar_caramel)): total_sugar;

% Constraints
% Calorie budget: total calories from both cakes cannot exceed the daily limit
constraint
  calories_cheesecake * cheesecake_slices + calories_caramel * caramel_slices <= max_calories;

% Preference/ratio requirement: at least 3 times as many cheesecake slices as caramel slices
constraint
  cheesecake_slices >= cheesecake_to_caramel_ratio * caramel_slices;

% Total sugar definition: link helper variable to sugar consumed from both cakes
constraint
  total_sugar = sugar_cheesecake * cheesecake_slices + sugar_caramel * caramel_slices;

% Objective
solve maximize total_sugar;