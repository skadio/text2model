% Parameters
int: maxShifts = 40;            % total available shifts in the month
int: maxEnergy = 230;           % total available energy units
int: minOrders = 320;           % minimum required delivered orders

int: bikeOrders = 10;           % orders delivered per bike shift
int: bikeEnergy = 5;            % energy used per bike shift
int: bikeTips   = 50;           % tips earned per bike shift

int: scooterOrders = 7;         % orders delivered per scooter shift
int: scooterEnergy = 6;         % energy used per scooter shift
int: scooterTips   = 43;        % tips earned per scooter shift

int: minScooterShifts = 5;      % minimum required scooter shifts

% Variables
var 0..maxShifts: bikeShifts;                      % number of bike shifts scheduled
var minScooterShifts..maxShifts: scooterShifts;    % number of scooter shifts scheduled

var 0..maxShifts: totalShifts;                     % total shifts (bike + scooter)
var 0..(bikeOrders * maxShifts): totalOrders;      % total orders delivered (bounded)
var 0..maxEnergy: totalEnergy;                     % total energy used (bounded)
var 0..(bikeTips * maxShifts): totalTips;          % total tips earned (bounded)

% Constraints
% --- Shift accounting ---
constraint totalShifts = bikeShifts + scooterShifts;
constraint totalShifts <= maxShifts;

% --- Orders requirement ---
constraint totalOrders = bikeOrders * bikeShifts + scooterOrders * scooterShifts;
constraint totalOrders >= minOrders;

% --- Energy budget ---
constraint totalEnergy = bikeEnergy * bikeShifts + scooterEnergy * scooterShifts;
constraint totalEnergy <= maxEnergy;

% --- Tips accounting ---
constraint totalTips = bikeTips * bikeShifts + scooterTips * scooterShifts;

% --- Minimum scooter shifts ---
constraint scooterShifts >= minScooterShifts;

% Objective
solve maximize totalTips;