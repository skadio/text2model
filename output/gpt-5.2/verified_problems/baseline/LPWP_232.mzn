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

var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): CircularTables;
var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): RectangularTables;

constraint
  SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables <= TotalSpace;

constraint
  ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables >= MinParticipants;

constraint
  BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables >= MinBoards;

var int: TotalGuests =
  GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;

solve maximize TotalGuests;

output [
  "CircularTables = ", show(CircularTables), ";\n",
  "RectangularTables = ", show(RectangularTables), ";\n",
  "TotalGuests = ", show(TotalGuests), ";\n",
  "TotalSpaceUsed = ", show(SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables), ";\n",
  "TotalParticipants = ", show(ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables), ";\n",
  "TotalBoards = ", show(BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables), ";\n"
];