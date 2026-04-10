include "globals.mzn";

int: N;  % Number of interventions
array[1..N] of int: IsolateCentral;  % Processing time for isolating at the central system
array[1..N] of int: ScanCentral;     % Processing time for scanning at the central system
array[1..N] of int: IsolateDistributed;  % Processing time for isolating at the distributed system
array[1..N] of int: ScanDistributed;     % Processing time for scanning at the distributed system
int: CentralCost;  % Cost for central system intervention
int: DistributedCost;  % Cost for distributed system intervention
int: CentralMaxHours;  % Maximum hours of operation for the central system
int: DistributedMaxHours;  % Maximum hours of operation for the distributed system

% Variables for start times of interventions
array[1..N] of var int: startCentral;  
array[1..N] of var int: startDistributed;  

% Calculate total durations for each intervention type
array[1..N] of int: durationCentral = [IsolateCentral[i] + ScanCentral[i] | i in 1..N];
array[1..N] of int: durationDistributed = [IsolateDistributed[i] + ScanDistributed[i] | i in 1..N];

% Usage arrays for cumulative constraints
array[1..N] of int: usageCentral = [1 | i in 1..N];  
array[1..N] of int: usageDistributed = [1 | i in 1..N];  

% Cumulative constraints for both processing systems
constraint cumulative(startCentral, durationCentral, usageCentral, CentralMaxHours);
constraint cumulative(startDistributed, durationDistributed, usageDistributed, DistributedMaxHours);

% Objective function: minimize total cost
var int: totalCost = sum(i in 1..N)( (startCentral[i] != 0) * CentralCost + (startDistributed[i] != 0) * DistributedCost );

% Solve the model
solve minimize totalCost;

% Output the results
output [ "Start Central = ", show(startCentral), "\n", 
         "Start Distributed = ", show(startDistributed), "\n", 
         "Total Cost = ", show(totalCost), "\n" ];