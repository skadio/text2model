% Parameters (with values embedded)
int: N = 6;                 % students 1..6
int: D = 5;                 % days 1..5 (Mon..Fri)
set of int: Students = 1..N;
set of int: Days = 1..D;

% Lab open hours: 8:00-22:00 => 14 hours per day
int: H = 14;

% Wages in tenths of CNY/hour (to keep integer linear model)
array[Students] of int: wage10 = [100, 100, 99, 98, 108, 113];

% Maximum duty hours per student per day (from table)
array[Students, Days] of int: maxHours =
array2d(Students, Days,
[
  6,0,6,0,7,    % student 1
  0,8,9,6,0,    % student 2
  4,8,3,0,5,    % student 3
  5,5,6,0,4,    % student 4
  3,0,5,8,0,    % student 5
  0,6,0,6,5     % student 6
]);

set of int: Undergrads = 1..4;
set of int: Grads = 5..6;

% Minimum weekly hours
int: minUG = 8;
int: minG  = 7;

% Shift limits (interpreting a shift as "works at least 1 hour on that day")
int: maxShiftsPerWeek = 2;

% Daily limit: no more than 3 distinct students scheduled per day
int: maxStudentsPerDay = 3;


% Variables
% Hours assigned to student i on day d
array[Students, Days] of var 0..H: x;

% Binary indicator: student i works (>=1 hour) on day d
array[Students, Days] of var 0..1: work;

% Total cost in tenths of CNY
var int: totalCost10;


% Constraints
% Respect daily maximum availability hours
constraint
  forall(i in Students, d in Days) (
    x[i,d] <= maxHours[i,d]
  );

% Exactly one and only one student on duty during all open hours each day
constraint
  forall(d in Days) (
    sum(i in Students)(x[i,d]) = H
  );

% Link "work" to hours (if any hour, then work=1; if work=0 then 0 hours)
constraint
  forall(i in Students, d in Days) (
    x[i,d] <= H * work[i,d]
  );
constraint
  forall(i in Students, d in Days) (
    x[i,d] >= work[i,d]        % ensures work=1 implies at least 1 hour
  );

% Weekly minimum hours per student group
constraint
  forall(i in Undergrads) (
    sum(d in Days)(x[i,d]) >= minUG
  );
constraint
  forall(i in Grads) (
    sum(d in Days)(x[i,d]) >= minG
  );

% Each student can work no more than 2 shifts per week
constraint
  forall(i in Students) (
    sum(d in Days)(work[i,d]) <= maxShiftsPerWeek
  );

% No more than 3 students scheduled per day
constraint
  forall(d in Days) (
    sum(i in Students)(work[i,d]) <= maxStudentsPerDay
  );

% Objective definition
constraint
  totalCost10 = sum(i in Students, d in Days)(wage10[i] * x[i,d]);


% Objective
solve minimize totalCost10;