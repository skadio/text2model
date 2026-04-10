% Parameters
int: calories_cheesecake = 200;        % calories per slice of cheesecake
int: sugar_cheesecake    = 40;         % sugar (g) per slice of cheesecake
int: calories_caramel    = 250;        % calories per slice of caramel cake
int: sugar_caramel       = 50;         % sugar (g) per slice of caramel cake

int: max_calories = 10000;             % maximum total calories allowed
int: min_caramel_slices = 3;           % minimum caramel cake slices
int: cheesecake_to_caramel_ratio = 3;  % must eat at least this many times cheesecake vs caramel

% Safe upper bounds derived from the calorie limit
int: max_cheesecake_slices = max_calories div calories_cheesecake;
int: max_caramel_slices    = max_calories div calories_caramel;

% Variables
var 0..max_cheesecake_slices: cheesecake_slices;  % number of cheesecake slices to eat
var 0..max_caramel_slices: caramel_slices;        % number of caramel cake slices to eat

var 0..max_calories: total_calories;              % total calories consumed
var 0..(sugar_cheesecake * max_cheesecake_slices + sugar_caramel * max_caramel_slices): total_sugar;
  % total sugar consumed (g)

% Constraints

% Link total calories to chosen slices
constraint total_calories =
  calories_cheesecake * cheesecake_slices +
  calories_caramel    * caramel_slices;

% Enforce daily calorie limit
constraint total_calories <= max_calories;

% Link total sugar to chosen slices
constraint total_sugar =
  sugar_cheesecake * cheesecake_slices +
  sugar_caramel    * caramel_slices;

% Minimum caramel cake slices requirement
constraint caramel_slices >= min_caramel_slices;

% Preference constraint: at least ratio times as many cheesecake as caramel
constraint cheesecake_slices >= cheesecake_to_caramel_ratio * caramel_slices;

% Objective
solve maximize total_sugar;