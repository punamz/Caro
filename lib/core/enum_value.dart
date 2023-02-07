enum CellValue { none, xChar, oChar, xWinner, oWinner }

enum Winner {
  me('You win'),
  opponent('You lose'),
  draw('Draw');

  const Winner(this.title);
  final String title;
}
