% Weekly training schedule optimization (all data embedded)

int: max_total_hours = 30;

int: fatigue_X = 10; % cardio
int: fatigue_Y = 15; % strength
int: fatigue_Z = 20; % flexibility

int: min_diff_XY = 5;  % X >= Y + 5
int: max_diff_ZX = 10; % |Z - X| <= 10

% Decision variables: integer hours for each exercise type
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..max_total_hours: Z;

% Constraints
constraint X + Y + Z <= max_total_hours;
constraint X >= Y + min_diff_XY;
constraint abs(Z - X) <= max_diff_ZX;

% Objective: minimize total fatigue score
var int: total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;
solve minimize total_fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];