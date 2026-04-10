% Parameters
int: costA = 50;
int: costB = 45;
int: costC = 40;

int: chairsPerOrderA = 15;
int: chairsPerOrderB = 10;
int: chairsPerOrderC = 10;

int: minChairs = 100;
int: maxChairs = 500;

% Variables
var 0..(maxChairs div chairsPerOrderA): xA; % number of orders from A
var 0..(maxChairs div chairsPerOrderB): xB; % number of orders from B
var 0..(maxChairs div chairsPerOrderC): xC; % number of orders from C

var 0..maxChairs: totalChairs;
var 0..(costA*(maxChairs div chairsPerOrderA) + costB*(maxChairs div chairsPerOrderB) + costC*(maxChairs div chairsPerOrderC)): totalCost;

% Constraints
constraint totalChairs = chairsPerOrderA * xA + chairsPerOrderB * xB + chairsPerOrderC * xC;
constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

% If ordering from A (xA > 0), then at least 10 chairs from B => at least 1 order from B
constraint xA > 0 -> xB >= 1;

% If ordering from B (xB > 0), then must also order from C (at least 1 order)
constraint xB > 0 -> xC >= 1;

constraint totalCost = costA * xA + costB * xB + costC * xC;

% Objective
solve minimize totalCost;