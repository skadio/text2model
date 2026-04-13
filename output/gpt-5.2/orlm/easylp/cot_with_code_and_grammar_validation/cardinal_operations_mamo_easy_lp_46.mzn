% Parameters
int: nurse_cost = 7;
int: doctor_cost = 10;

% (At least the equivalent of 20 hours of work from two nurses or one doctor)
% Interpreted as: 2*nurse_hours + doctor_hours >= 20
int: demand = 20;

% (Combined hours worked by one nurse and three doctors cannot exceed 60 hours)
% Interpreted as: nurse_hours + 3*doctor_hours <= 60
int: cap = 60;

% Upper bounds derived from constraints:
% From 2N + D >= 20 and N >= 0, D >= 0 -> not an upper bound.
% From N + 3D <= 60 -> N <= 60 and D <= 20
int: nurse_ub = 60;
int: doctor_ub = 20;

% Variables
var 0..nurse_ub: nurse_hours;
var 0..doctor_ub: doctor_hours;

% Constraints
constraint 2 * nurse_hours + doctor_hours >= demand;
constraint nurse_hours + 3 * doctor_hours <= cap;

% Objective
solve minimize nurse_cost * nurse_hours + doctor_cost * doctor_hours;