% Parameters
int: costX = 5000;          % Cost per hire in department X
int: costY = 7000;          % Cost per hire in department Y
int: costZ = 10000;         % Cost per hire in department Z

int: maxTotalHires = 50;    % Maximum total hires across all departments

int: minX = 10;             % Minimum hires required in department X
int: minY = 15;             % Minimum hires required in department Y
int: minZ = 20;             % Minimum hires required in department Z


% Variables
var minX..maxTotalHires: hiresX;  % Number of hires in department X
var minY..maxTotalHires: hiresY;  % Number of hires in department Y
var minZ..maxTotalHires: hiresZ;  % Number of hires in department Z


% Constraints
% Total hiring limit across all departments
constraint hiresX + hiresY + hiresZ <= maxTotalHires;

% Minimum hiring requirements per department (also enforced by variable domains)
constraint hiresX >= minX;
constraint hiresY >= minY;
constraint hiresZ >= minZ;


% Objective
solve minimize costX * hiresX + costY * hiresY + costZ * hiresZ;