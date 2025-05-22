% Parameters
int: Period;                           % consecutive working days (1..7)
array[1..7] of int: Demand;            % nurses required for each day (Mon-Sun)

set of int: DAYS = 1..7;               % index set for the week

% Upper bound on the total number of nurses possibly needed
int: MaxN = sum(d in DAYS)(Demand[d]);

% Variables
array[DAYS] of var 0..MaxN: NursesStart;   % NursesStart[d] = nurses whose first working day is day d

% Constraints
constraint
    forall(day in DAYS)(
        sum(start in DAYS)(
            NursesStart[start] * bool2int( ((day - start + 7) mod 7) < Period )
        ) >= Demand[day]
    );

% Objective
solve minimize sum(start in DAYS)(NursesStart[start]);