% Parameters
int: Period;                           % Planning period (e.g., number of weeks/cycles considered)
int: DaysInWeek = 7;                   % Number of days in a week (fixed)
array[1..DaysInWeek] of int: Demand;   % Required nurses per night shift for each day of the week

% Helpful derived bounds/constants
int: MaxDemand = max(Demand);
int: TotalDemand = sum(d in 1..DaysInWeek)(Demand[d]);

% Variables
var 0..DaysInWeek: workDaysInRow;                          % x = number of consecutive night-shift work days
var 0..DaysInWeek: daysOff;                                % 7-x = number of consecutive days off

var 0..(Period * TotalDemand): nursesHired;                % Total number of nurses to hire (objective)

array[1..DaysInWeek] of var 0..(Period * TotalDemand): startWork;
% startWork[d] = number of nurses whose work-block starts on day d (cyclic over the week)

% Constraints

% --- Work/off pattern definition (x work days followed by 7-x off days) ---
constraint workDaysInRow + daysOff = DaysInWeek;

% Disallow the degenerate cases (all off or all work), to keep a meaningful pattern
constraint workDaysInRow >= 1 /\ workDaysInRow <= DaysInWeek - 1;

% --- Link hired nurses to chosen configuration (how many start their work block) ---
constraint nursesHired = sum(d in 1..DaysInWeek)(startWork[d]);

% --- Coverage constraints: for each weekday, enough nurses are working to meet demand ---
% A nurse starting on day s works on days s, s+1, ..., s+(workDaysInRow-1) (mod 7).
constraint
  forall(day in 1..DaysInWeek) (
    sum(s in 1..DaysInWeek)(
      startWork[s] *
      bool2int( ((day - s + DaysInWeek) mod DaysInWeek) < workDaysInRow )
    ) >= Demand[day]
  );

% --- Optional symmetry breaking: if no one is hired, don't care about start distribution ---
constraint (nursesHired = 0) -> forall(d in 1..DaysInWeek)(startWork[d] = 0);

% Objective
solve minimize nursesHired;