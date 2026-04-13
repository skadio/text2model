% Science fair table planning: maximize guests subject to space and minimum requirements.

%-------------------- Input data --------------------
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

%-------------------- Decision variables --------------------
% Numbers of each table type to set up
var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): CircularTables;
var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): RectangularTables;

%-------------------- Constraints --------------------
constraint
  SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables <= TotalSpace;

constraint
  ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables >= MinParticipants;

constraint
  BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables >= MinBoards;

%-------------------- Objective --------------------
var int: TotalGuests =
  GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;

solve maximize TotalGuests;

%-------------------- Output --------------------
output [
  "CircularTables = ", show(CircularTables), "\n",
  "RectangularTables = ", show(RectangularTables), "\n",
  "TotalGuests = ", show(TotalGuests), "\n",
  "UsedSpace = ", show(SpacePerCircular*CircularTables + SpacePerRectangular*RectangularTables), " / ", show(TotalSpace), "\n",
  "TotalParticipants = ", show(ParticipantsPerCircular*CircularTables + ParticipantsPerRectangular*RectangularTables), " (min ", show(MinParticipants), ")\n",
  "TotalBoards = ", show(BoardsPerCircular*CircularTables + BoardsPerRectangular*RectangularTables), " (min ", show(MinBoards), ")\n"
];