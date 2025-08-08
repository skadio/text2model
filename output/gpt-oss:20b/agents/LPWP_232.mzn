%------------------------------------------
%  Science Fair Table Planning Model
%------------------------------------------
include "globals.mzn";

% Parameters (provided in the .dzn file)
int: CircularTables;            % optional maximum number of circular tables (if any)
int: RectangularTables;         % optional maximum number of rectangular tables (if any)
int: ParticipantsPerCircular;
int: ParticipantsPerRectangular;
int: BoardsPerCircular;
int: BoardsPerRectangular;
int: GuestsPerCircular;
int: GuestsPerRectangular;
int: SpacePerCircular;
int: SpacePerRectangular;
int: TotalSpace;
int: MinParticipants;
int: MinBoards;

% Upper bound for the number of tables that could possibly fit in the space
int: maxTables = TotalSpace div min(SpacePerCircular, SpacePerRectangular);

% Decision variables
var 0..maxTables: circularCount;
var 0..maxTables: rectangularCount;

% Derived totals
var 0..TotalSpace: spaceUsed = 
    circularCount * SpacePerCircular
  + rectangularCount * SpacePerRectangular;

var 0..TotalSpace: participants =
    circularCount * ParticipantsPerCircular
  + rectangularCount * ParticipantsPerRectangular;

var 0..TotalSpace: boards =
    circularCount * BoardsPerCircular
  + rectangularCount * BoardsPerRectangular;

var 0..TotalSpace: guests =
    circularCount * GuestsPerCircular
  + rectangularCount * GuestsPerRectangular;

% Constraints
constraint spaceUsed <= TotalSpace;
constraint participants >= MinParticipants;
constraint boards >= MinBoards;

% Optional: respect any supplied upper limits on tables
constraint circularCount <= CircularTables;
constraint rectangularCount <= RectangularTables;

% Objective: maximise the number of guests
solve maximize guests;

% Output
output [
  "Circular tables  : ", show(circularCount), "\n",
  "Rectangular tables: ", show(rectangularCount), "\n",
  "Total space used  : ", show(spaceUsed), " / ", show(TotalSpace), "\n",
  "Total participants: ", show(participants), " >= ", show(MinParticipants), "\n",
  "Total boards      : ", show(boards), " >= ", show(MinBoards), "\n",
  "Total guests      : ", show(guests), "\n"
];