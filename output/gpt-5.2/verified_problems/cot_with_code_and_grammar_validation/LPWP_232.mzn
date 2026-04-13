int: CircularTables = 0;
int: RectangularTables = 0;

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

var 0..CircularTables: numCircular;
var 0..RectangularTables: numRectangular;

var int: totalGuests;

constraint SpacePerCircular * numCircular + SpacePerRectangular * numRectangular <= TotalSpace;
constraint ParticipantsPerCircular * numCircular + ParticipantsPerRectangular * numRectangular >= MinParticipants;
constraint BoardsPerCircular * numCircular + BoardsPerRectangular * numRectangular >= MinBoards;
constraint totalGuests = GuestsPerCircular * numCircular + GuestsPerRectangular * numRectangular;

solve maximize totalGuests;