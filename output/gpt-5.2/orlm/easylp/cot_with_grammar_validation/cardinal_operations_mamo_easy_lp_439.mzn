% Parameters
int: costDoctor = 5;
int: costNurse = 3;

int: demandMin = 50;         % 2*Doctors + Nurses >= 50
int: balanceMax = 100;       % Doctors + 3*Nurses <= 100
int: doctorLeadMin = 10;     % Doctors - Nurses >= 10

% Variable bounds derived from constraints:
% From Doctors - Nurses >= 10 and Nurses >= 0 => Doctors >= 10
% From Doctors + 3*Nurses <= 100 and Doctors >= 0 => Nurses <= 33
% From Doctors + 3*Nurses <= 100 and Nurses >= 0 => Doctors <= 100
int: maxDoctors = 100;
int: maxNurses = 33;

% Variables
var 0..maxDoctors: Doctors;
var 0..maxNurses: Nurses;

var 0..(costDoctor*maxDoctors + costNurse*maxNurses): TotalCost;

% Constraints
constraint 2*Doctors + Nurses >= demandMin;
constraint Doctors + 3*Nurses <= balanceMax;
constraint Doctors - Nurses >= doctorLeadMin;

constraint TotalCost = costDoctor*Doctors + costNurse*Nurses;

% Objective
solve minimize TotalCost;