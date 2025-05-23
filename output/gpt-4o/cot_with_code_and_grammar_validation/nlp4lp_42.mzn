% Parameters
int: N;                                           % Number of days in the planning horizon
array[1..N] of int: Num;                          % Required employees per day
int: WorkingDays;                                 % Consecutive working days
int: RestingDays;                                 % Consecutive resting days

int: P = WorkingDays + RestingDays;               % Length of one full work–rest cycle
int: MaxEmployees = sum(d in 1..N)(Num[d]);       % A safe upper bound on staff

% Variables
array[1..P] of var 0..MaxEmployees: x;            % x[p] = employees whose cycle starts on offset p
var 0..MaxEmployees: TotalEmployees = sum(p in 1..P)(x[p]);

% Constraints
constraint
    forall(d in 1..N)(
        sum(p in 1..P where ((d - p) mod P) < WorkingDays)(x[p]) >= Num[d]
    );

% Objective
solve minimize TotalEmployees;