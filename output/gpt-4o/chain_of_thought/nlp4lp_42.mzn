% Parameters
int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

% Derived constants
int: CycleLength = WorkingDays + RestingDays;
int: Horizon      = N * CycleLength;                       % period where both patterns align
int: MaxEmployees = sum(d in 1..N)(Num[d]) * CycleLength;  % safe upper bound

% Decision variables: employees whose first working day is offset o in the cycle
array[1..CycleLength] of var 0..MaxEmployees: employees_offset;

% Coverage constraints over the combined horizon
constraint
  forall(t in 1..Horizon)(
    sum(o in 1..CycleLength)(
      ((t - o + CycleLength) mod CycleLength) < WorkingDays
      ? employees_offset[o] : 0
    ) >= Num[((t - 1) mod N) + 1]
  );

% Objective
solve minimize sum(o in 1..CycleLength)(employees_offset[o]);