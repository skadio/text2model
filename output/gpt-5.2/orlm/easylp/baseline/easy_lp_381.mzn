% Training hours allocation - minimize total fatigue score

% Decision variables: weekly hours (integers)
var 0..100: X1; % strength conditioning
var 0..100: X2; % skill development
var 0..100: X3; % strategy and tactics
var 0..100: X4; % recovery

% Fatigue per hour
int: f1 = 5;
int: f2 = 4;
int: f3 = 3;
int: f4 = 6;

% Constraints
constraint X1 + X2 <= 15;
constraint X2 + X3 >= 10;
constraint abs(X3 - X4) <= 8;
constraint X1 >= 2 * X4 + 5;

% Objective: minimize total fatigue
var int: total_fatigue = f1*X1 + f2*X2 + f3*X3 + f4*X4;
solve minimize total_fatigue;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total fatigue score (rounded) = ", show(total_fatigue), "\n"
];