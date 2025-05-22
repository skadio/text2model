% Parameters
int: Period;                                   % Consecutive working days for every nurse
array[1..7] of int: Demand;                    % Night-shift demand for each day of the week
int: MaxNurses = sum(i in 1..7)(Demand[i]);    % Safe upper bound on required nurses

% Variables
array[1..7] of var 0..MaxNurses: Start;        % Start[d] = nurses whose 7-day cycle starts on day d
var 0..MaxNurses: TotalNurses;                 % Total nurses hired

% Constraints
constraint
    TotalNurses = sum(d in 1..7)(Start[d]);

constraint
    forall(t in 1..7)(
        sum(d in 1..7)(
            Start[d] * bool2int( ((t - d + 7) mod 7) < Period )
        ) >= Demand[t]
    );

% Objective
solve minimize TotalNurses;