include "globals.mzn";

% Data (embedded as requested)
int: reqHours = 1000;
int: budget   = 40000;

int: hoursStaff = 6;
int: payStaff   = 300;

int: hoursSub = 3;
int: paySub   = 100;

% Decision variables: number of staff and substitute teachers (nonnegative integers)
var 0..ceil(reqHours div hoursStaff) + reqHours: staff;
var 0..reqHours: subs;

% Constraints
constraint hoursStaff * staff + hoursSub * subs >= reqHours;
constraint payStaff * staff + paySub * subs <= budget;

% Objective: minimize total number of teachers hired
var 0..(ceil(reqHours div hoursStaff) + reqHours): totalTeachers = staff + subs;

solve minimize totalTeachers;

output [
  "staff = ", show(staff), "\n",
  "subs = ", show(subs), "\n",
  "totalTeachers = ", show(totalTeachers), "\n",
  "totalHours = ", show(hoursStaff*staff + hoursSub*subs), "\n",
  "totalCost = ", show(payStaff*staff + paySub*subs), "\n"
];