include "globals.mzn";

%-----------------------------
% Data (embedded from table)
%-----------------------------
int: nStudents = 6;
int: nDays = 5;
set of int: Students = 1..nStudents;
set of int: Days = 1..nDays;

% Lab open hours per day: 8:00 to 22:00 => 14 hours
int: openHoursPerDay = 14;
array[Days] of int: openHours = [openHoursPerDay | d in Days];

% Wages (CNY/hour)
array[Students] of float: wage = [10.0, 10.0, 9.9, 9.8, 10.8, 11.3];

% Max duty hours available per student per day (Mon..Fri)
% day index: 1=Mon,2=Tue,3=Wed,4=Thu,5=Fri
array[Students, Days] of int: maxHours =
array2d(Students, Days,
[
  6, 0, 6, 0, 7,   % student 1
  0, 8, 9, 6, 0,   % student 2
  4, 8, 3, 0, 5,   % student 3
  5, 5, 6, 0, 4,   % student 4
  3, 0, 5, 8, 0,   % student 5
  0, 6, 0, 6, 5    % student 6
]);

set of int: Undergrads = 1..4;
set of int: Grads = 5..6;

int: minHoursUG = 8;
int: minHoursG  = 7;

int: maxShiftsPerWeek = 2;
int: maxStudentsPerDay = 3;

%-----------------------------
% Decision variables
%-----------------------------
% hours[s,d] = number of hours student s works on day d
array[Students, Days] of var 0..openHoursPerDay: hours;

% works[s,d] = 1 iff student s works (positive hours) on day d
array[Students, Days] of var 0..1: works;

%-----------------------------
% Core constraints
%-----------------------------

% Link works and hours; also enforce individual daily availability caps
constraint forall(s in Students, d in Days) (
  hours[s,d] <= maxHours[s,d] /\
  hours[s,d] <= openHours[d] /\
  (hours[s,d] > 0) <-> (works[s,d] = 1)
);

% Exactly one and only one student on duty during all open hours each day:
% i.e., the sum of allocated hours equals the daily open hours.
constraint forall(d in Days)(
  sum(s in Students)(hours[s,d]) = openHours[d]
);

% Minimum weekly hours: undergrads >= 8, grads >= 7
constraint forall(s in Undergrads)(
  sum(d in Days)(hours[s,d]) >= minHoursUG
);
constraint forall(s in Grads)(
  sum(d in Days)(hours[s,d]) >= minHoursG
);

% Each student can work no more than 2 shifts (days) per week
array[Students] of var 0..nDays: shiftsPerWeek;
constraint forall(s in Students)(
  count([ works[s,d] | d in Days ], 1, shiftsPerWeek[s]) /\
  shiftsPerWeek[s] <= maxShiftsPerWeek
);

% No more than 3 students can be scheduled (work any hours) each day
array[Days] of var 0..nStudents: studentsPerDay;
constraint forall(d in Days)(
  count([ works[s,d] | s in Students ], 1, studentsPerDay[d]) /\
  studentsPerDay[d] <= maxStudentsPerDay
);

%-----------------------------
% Objective: minimize gross pay
%-----------------------------
var float: totalPay =
  sum(s in Students, d in Days)( wage[s] * int2float(hours[s,d]) );

solve minimize totalPay;

%-----------------------------
% Output
%-----------------------------
output [
  "Total pay (CNY) = ", show(totalPay), "\n\n",
  "Hours matrix (students 1..6 x days Mon..Fri):\n",
  concat([ concat([ show(hours[s,d]) ++ if d<nDays then "\t" else "" endif
                   | d in Days ]) ++ "\n"
         | s in Students ]),
  "\nShifts per week: ", show(shiftsPerWeek), "\n",
  "Students per day: ", show(studentsPerDay), "\n"
];