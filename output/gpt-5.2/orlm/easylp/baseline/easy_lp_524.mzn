% Hospital staffing allocation - all data embedded

int: max_total_hours = 100;

int: cost_nurse = 500;   % X
int: cost_doctor = 300;  % Y
int: cost_admin = 700;   % Z

% Bounds (not explicitly given; use natural weekly bounds within total limit)
var 0..max_total_hours: X; % nurses hours
var 0..max_total_hours: Y; % doctors hours
var 0..max_total_hours: Z; % admin hours

constraint X + Y + Z <= max_total_hours;

% difference between nurses and doctors at least 10 (absolute difference)
constraint abs(X - Y) >= 10;

% difference between admin and nurses should not exceed 20 (absolute difference)
constraint abs(Z - X) <= 20;

% at least 30 more admin hours than doctor hours
constraint Z >= Y + 30;

var int: total_cost = cost_nurse * X + cost_doctor * Y + cost_admin * Z;

solve minimize total_cost;

output [
  "X(nurses)=", show(X), " hours\n",
  "Y(doctors)=", show(Y), " hours\n",
  "Z(admin)=", show(Z), " hours\n",
  "TotalHours=", show(X+Y+Z), "\n",
  "MinTotalCost=$", show(total_cost), "\n"
];