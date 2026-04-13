% Hospital staffing hours optimization (embedded data)

int: maxTotalHours = 100;

int: costNurse = 500;
int: costDoctor = 300;
int: costAdmin = 700;

% Whole-number weekly hours (nonnegative, bounded by the total-hours cap)
var 0..maxTotalHours: X; % nurses
var 0..maxTotalHours: Y; % doctors
var 0..maxTotalHours: Z; % administrative personnel

% Constraints
constraint X + Y + Z <= maxTotalHours;

% difference in work hours between nurses and doctors must be at least 10
constraint abs(X - Y) >= 10;

% difference in work hours between administrative personnel and nurses should not exceed 20
constraint abs(Z - X) <= 20;

% at least 30 more hours allocated to administrative tasks than doctor's hours
constraint Z >= Y + 30;

% Objective: minimize total staffing cost
var int: totalCost = costNurse * X + costDoctor * Y + costAdmin * Z;

solve minimize totalCost;

output [
  "X (nurses hours) = ", show(X), "\n",
  "Y (doctors hours) = ", show(Y), "\n",
  "Z (admin hours)   = ", show(Z), "\n",
  "Total cost ($)    = ", show(totalCost), "\n"
];