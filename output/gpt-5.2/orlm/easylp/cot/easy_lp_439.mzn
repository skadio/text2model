% Parameters (with values embedded)
int: costDoctor = 5;
int: costNurse  = 3;

int: demandMin = 50;        % 2*Doctors + Nurses >= 50
int: balanceMax = 100;      % Doctors + 3*Nurses <= 100
int: doctorExcess = 10;     % Doctors >= Nurses + 10

% Variable bounds derived from constraints:
% From Doctors >= Nurses + 10 and 2*Doctors + Nurses >= 50 => 3*Doctors - 10 >= 50 => Doctors >= 20
% Also Nurses >= 0 and Doctors >= 0
% Upper bound for Doctors: from Doctors + 3*Nurses <= 100 and Nurses >= 0 => Doctors <= 100
int: maxDoctors = 100;
int: maxNurses  = 100;

% Variables
var 0..maxDoctors: Doctors;
var 0..maxNurses: Nurses;

% Constraints
constraint 2 * Doctors + Nurses >= demandMin;
constraint Doctors + 3 * Nurses <= balanceMax;
constraint Doctors >= Nurses + doctorExcess;

% Objective
var int: TotalCost = costDoctor * Doctors + costNurse * Nurses;
solve minimize TotalCost;

output [
  "Doctors = ", show(Doctors), "\n",
  "Nurses  = ", show(Nurses), "\n",
  "MinTotalCost = ", show(TotalCost), "\n"
];