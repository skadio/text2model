% Parameters
% Enrollment capacity constraints
int: capXY = 30;        % Maximum students in courses X + Y
int: capYZ = 20;        % Maximum students in courses Y + Z
int: minXZ = 10;        % Minimum students in courses X + Z

% Cost per enrolled student
int: costX = 5;         % Cost per student in course X
int: costY = 3;         % Cost per student in course Y
int: costZ = 1;         % Cost per student in course Z


% Variables
var 0..capXY: studentsX;                       % Enrolled students in course X
var 0..capXY: studentsY;                       % Enrolled students in course Y
var 0..capYZ: studentsZ;                       % Enrolled students in course Z

% Upper bound is a safe worst-case cost within variable domains
var 0..(costX*capXY + costY*capXY + costZ*capYZ): totalCost;  % Total operational cost


% Constraints
% Capacity constraints on combined enrollments
constraint studentsX + studentsY <= capXY;  % X + Y cannot exceed classroom capacity
constraint studentsY + studentsZ <= capYZ;  % Y + Z cannot exceed faculty availability

% Minimum diversity / offering constraint
constraint studentsX + studentsZ >= minXZ;  % X + Z must be at least the required minimum

% Total cost definition (linking variable totalCost to enrollments)
constraint totalCost = costX * studentsX + costY * studentsY + costZ * studentsZ;


% Objective
solve minimize totalCost;

output [
  "studentsX=", show(studentsX), "\n",
  "studentsY=", show(studentsY), "\n",
  "studentsZ=", show(studentsZ), "\n",
  "totalCost=", show(totalCost), "\n"
];