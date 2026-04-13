% Training hours allocation minimizing total fatigue

int: fatigue_X = 10;
int: fatigue_Y = 20;

int: max_weighted_hours = 60;  % 3*X + 2*Y <= 60
int: min_total_hours = 12;     % X + Y >= 12
int: max_diff = 8;             % |Y - X| <= 8

% Upper bounds derived from 3*X + 2*Y <= 60
int: X_ub = 20;  % if Y=0 => 3X<=60
int: Y_ub = 30;  % if X=0 => 2Y<=60

var 0..X_ub: X;  % hours for group X (strength)
var 0..Y_ub: Y;  % hours for group Y (skill)

constraint 3*X + 2*Y <= max_weighted_hours;
constraint X + Y >= min_total_hours;
constraint abs(Y - X) <= max_diff;

var int: total_fatigue = fatigue_X * X + fatigue_Y * Y;

solve minimize total_fatigue;

output [
  "X_hours=", show(X), "\n",
  "Y_hours=", show(Y), "\n",
  "min_total_fatigue=", show(total_fatigue), "\n"
];