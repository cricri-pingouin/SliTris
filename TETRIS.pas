unit TETRIS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, IniFiles;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mniExit: TMenuItem;
    N2: TMenuItem;
    mniSettings: TMenuItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    lblScoreHeader: TLabel;
    lblScore: TLabel;
    lblLinesHeader: TLabel;
    lblLines: TLabel;
    imgNext: TImage;
    lblNext: TLabel;
    lblStats: TLabel;
    lblStat1: TLabel;
    lblStat2: TLabel;
    lblStat3: TLabel;
    lblStat4: TLabel;
    lblStat5: TLabel;
    lblStat6: TLabel;
    lblStat7: TLabel;
    grpSeparator: TGroupBox;
    lblLevelHeader: TLabel;
    lblLevel: TLabel;
    mniNew: TMenuItem;
    mniAbort: TMenuItem;
    mniPause: TMenuItem;
    mniKeys: TMenuItem;
    mniN3: TMenuItem;
    mniHighscores: TMenuItem;
    ImageBlank: TImage;
    function PieceCollided: Boolean;
    procedure CheckLines;
    procedure FormCreate(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure mniSettingsClick(Sender: TObject);
    procedure DrawShape(ShapeNum, ShapeRotation, X, Y: Word);
    procedure MovePieceDown;
    procedure DrawBrick(X, Y, Brick: Word);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MovePieceLeft;
    procedure MovePieceRight;
    procedure RotatePiece(Clockwise: Boolean);
    procedure NewGame;
    procedure DrawScore;
    procedure TogglePause;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniKeysClick(Sender: TObject);
    procedure mniPauseClick(Sender: TObject);
    procedure mniAbortClick(Sender: TObject);
    procedure mniNewClick(Sender: TObject);
    procedure mniHighscoresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //Settings
    OptHeight, OptDensity, OptLvlChg, OptSpeed: Byte;
    OptNext: Boolean;
    //High scores
    HSname: array[1..10] of string;
    HSscore: array[1..10] of DWORD;
    HSlines: array[1..10] of DWORD;
  end;

type
  a_Shape = array[1..4, 1..4] of Boolean;

  FullShape = array[1..4] of a_Shape;

const
  BrickSize = 33; //Size of a brick in pixels
  BoardSizeX = 10; //Width of playing board
  BoardSizeY = 20; //Height of playing board
  //1: I, cyan
  Shape1: FullShape = (((False, False, False, False), (True, True, True, True), (False, False, False, False), (False, False, False, False)), ((False, True, False, False), (False, True, False, False), (False, True, False, False), (False, True, False, False)), ((False, False, False, False), (True, True, True, True), (False, False, False, False), (False, False, False, False)), ((False, True, False, False), (False, True, False, False), (False, True, False, False), (False, True, False, False)));
    //2: T, purple
  Shape2: FullShape = (((False, True, False, False), (True, True, True, False), (False, False, False, False), (False, False, False, False)), ((False, True, False, False), (True, True, False, False), (False, True, False, False), (False, False, False, False)), ((False, False, False, False), (True, True, True, False), (False, True, False, False), (False, False, False, False)), ((False, True, False, False), (False, True, True, False), (False, True, False, False), (False, False, False, False)));
    //3: O, yellow
  Shape3: FullShape = (((False, True, True, False), (False, True, True, False), (False, False, False, False), (False, False, False, False)), ((False, True, True, False), (False, True, True, False), (False, False, False, False), (False, False, False, False)), ((False, True, True, False), (False, True, True, False), (False, False, False, False), (False, False, False, False)), ((False, True, True, False), (False, True, True, False), (False, False, False, False), (False, False, False, False)));
    //4: Z, red
  Shape4: FullShape = (((True, True, False, False), (False, True, True, False), (False, False, False, False), (False, False, False, False)), ((False, True, False, False), (True, True, False, False), (True, False, False, False), (False, False, False, False)), ((False, False, False, False), (True, True, False, False), (False, True, True, False), (False, False, False, False)), ((False, False, True, False), (False, True, True, False), (False, True, False, False), (False, False, False, False)));
  //5:  S, lime green
  Shape5: FullShape = (((False, True, True, False), (True, True, False, False), (False, False, False, False), (False, False, False, False)), ((True, False, False, False), (True, True, False, False), (False, True, False, False), (False, False, False, False)), ((False, False, False, False), (False, True, True, False), (True, True, False, False), (False, False, False, False)), ((False, True, False, False), (False, True, True, False), (False, False, True, False), (False, False, False, False)));
  //6: L, orange
  Shape6: FullShape = (((True, True, True, False), (True, False, False, False), (False, False, False, False), (False, False, False, False)), ((True, False, False, False), (True, False, False, False), (True, True, False, False), (False, False, False, False)), ((False, False, False, False), (False, False, True, False), (True, True, True, False), (False, False, False, False)), ((False, True, True, False), (False, False, True, False), (False, False, True, False), (False, False, False, False)));
  //7: J, blue
  Shape7: FullShape = (((True, True, True, False), (False, False, True, False), (False, False, False, False), (False, False, False, False)), ((True, True, False, False), (True, False, False, False), (True, False, False, False), (False, False, False, False)), ((False, False, False, False), (True, False, False, False), (True, True, True, False), (False, False, False, False)), ((False, False, True, False), (False, False, True, False), (False, True, True, False), (False, False, False, False)));

type
  ShapeRec = record
    P: ^TBitmap;
    Def: FullShape;
  end;

  XYRec = record
    X, Y: ShortInt;
    ShapeNum, ShapeRot: ShortInt;
  end;

var
  Form1: TForm1;
  Shape: array[1..7] of ShapeRec;
  CurShape: XYRec;
  BlankPic: ^TBitmap;
  NextShape: Byte;
  Brick: array[0..BoardSizeX + 1, 0..BoardSizeY + 1] of Byte; //0 and Tot+1 = fixed border
  //Scoring
  Score: DWord;
  Lines: DWord;
  Level: Byte;
  LevelTime: DWord; //Timer
  //Flags
  EndGame, Paused: Boolean;

implementation

{$R *.dfm}

uses
  OPTIONS, HIGHSCORES;

function TForm1.PieceCollided: Boolean;
var
  X, Y: Byte;
begin
  Result := False;
  //Is there anything on the board where a square needs to be?
  for Y := 4 downto 1 do //Starting from bottom will detect collision in fewer loops!
    for X := 1 to 4 do
      if (Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True) and (Brick[CurShape.X + X - 1, CurShape.Y + Y] > 0) then
      begin
        //Yes: declare collision and exit
        Result := True;
        Exit;
      end;
end;

procedure TForm1.CheckLines;
var
  X, Y, R, LinesNum: Word;
  LineEventLines: array[1..BoardSizeY] of Boolean;
begin
  LinesNum := 20;
  for Y := 1 to BoardSizeY do
    LineEventLines[Y] := True;
  for Y := 1 to BoardSizeY do
    for X := 1 to BoardSizeX do
      if Brick[X, Y] = 0 then
      begin
        LineEventLines[Y] := False;
        Dec(LinesNum);
        Break;
      end;
  if LinesNum = 0 then
    Exit;
  //Update lines completed count
  Inc(Lines, LinesNum);
  //Update score depending on number of lines
  case LinesNum of
    1:
      Inc(Score, 100);
    2:
      Inc(Score, 300);
    3:
      Inc(Score, 500);
    4:
      Inc(Score, 800);
  end;
  //Blink lines 20 times, 20 ms each = 0.4s total
  for R := 1 to 10 do
  begin
    Application.ProcessMessages;
    for Y := 1 to BoardSizeY do
      if LineEventLines[Y] then
        for X := 1 to BoardSizeX do
          DrawBrick(X, Y, R mod 7 + 1);
    Sleep(20);
  end;
  //Delete Full Lines
  for Y := 1 to BoardSizeY do
    if LineEventLines[Y] then
    begin
      //Full line: empty in Brick matrix
      for X := 1 to BoardSizeX do
        Brick[X, Y] := 0;
      //Shift upper lines down, down to line 2 which will get line 1
      for R := Y downto 2 do
        for X := 1 to BoardSizeX do
          Brick[X, R] := Brick[X, R - 1];
    end;
  //Set level
  Level := (Lines div OptLvlChg) + 1;
  if (Level > 10) then
    Level := 10;
  LevelTime := (11 - Level) * (150 - OptSpeed * 10);
  //ReDraw board
  if not Paused then
    for X := 1 to BoardSizeX do
      for Y := 1 to BoardSizeY do
        DrawBrick(X, Y, Brick[X, Y]);
end;

procedure TForm1.DrawBrick(X, Y, Brick: Word);
begin
  if Brick = 0 then
    Form1.Canvas.Draw((X - 1) * BrickSize, (Y - 1) * BrickSize, BlankPic^)
  else
    Form1.Canvas.Draw((X - 1) * BrickSize, (Y - 1) * BrickSize, Shape[Brick].P^);
end;

procedure TForm1.NewGame;
var
  X, Y, RX, RC: ShortInt;
  CurrTick, PrevTick: DWORD;
  //High score
  myINI: TINIFile;
  WinnerName: string;
begin
  Randomize;
  Lines := 0;
  Score := 0;
  EndGame := False;
  Paused := False;
  //Clear board
  //Logically
  for X := 0 to BoardSizeX + 1 do
    for Y := 0 to BoardSizeY + 1 do
      Brick[X, Y] := 1;
  for X := 1 to BoardSizeX do
    for Y := 1 to BoardSizeY do
      Brick[X, Y] := 0;
  //Graphically
  for X := 1 to BoardSizeX do
    for Y := 1 to BoardSizeY do
      DrawBrick(X, Y, 0);
  //Add handicap
  if (OptHeight > 0) then
    for Y := BoardSizeY downto (BoardSizeY - OptHeight + 1) do
      for X := 1 to OptDensity do
      begin
        RX := Random(10) + 1;
        RC := Random(7) + 1;
        Brick[RX, Y] := RC;
        DrawBrick(RX, Y, RC);
      end;
  //Update menu
  mniNew.Enabled := False;
  mniPause.Enabled := True;
  mniAbort.Enabled := True;
  //Initialise statistics
  lblStat1.Caption := '0';
  lblStat2.Caption := '0';
  lblStat3.Caption := '0';
  lblStat4.Caption := '0';
  lblStat5.Caption := '0';
  lblStat6.Caption := '0';
  lblStat7.Caption := '0';
  CurShape.X := 4;
  CurShape.Y := 0; //Set to 0, this will be increased to 1
  CurShape.ShapeNum := Random(7) + 1;
  CurShape.ShapeRot := 1;
  NextShape := Random(7) + 1;
  Level := 1;
  LevelTime := (11 - Level) * (150 - OptSpeed * 10);
  DrawScore;
  PrevTick := GetTickCount();
  repeat
  begin
    CurrTick := GetTickCount();
    if ((CurrTick - PrevTick) >= LevelTime) and not Paused then
    begin
      PrevTick := CurrTick;
      if (PieceCollided) then
      begin
        if (CurShape.Y <= 1) then
          //begin
          EndGame := True //;
            //Exit;
          //end
        else
        begin
          //Commit current shape to game board
          for X := 1 to 4 do
            for Y := 1 to 4 do
              if Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True then
                Brick[CurShape.X + X - 1, CurShape.Y + Y - 1] := CurShape.ShapeNum;
          CheckLines;
          PrevTick := GetTickCount(); //Lots of things might have happened, reset timer for new part
          //Set new shape parameters
          CurShape.ShapeNum := NextShape;
          CurShape.ShapeRot := 1;
          CurShape.X := 4;
          CurShape.Y := 1;
          //Display new shape
          DrawShape(CurShape.ShapeNum, CurShape.ShapeRot, CurShape.X, CurShape.Y);
          //Choose next shape
          NextShape := Random(7) + 1;
          //Refresh score/lines/next shape/statistics
          DrawScore;
          //Check if new piece collides on arrival = end game
          if (PieceCollided) then
            EndGame := True;
        end;
      end
      else
        MovePieceDown;
    end
    else
    begin
      Application.ProcessMessages;
      Sleep(15);
    end;
  end;
  until (EndGame) or (Application.Terminated);
  //Game over, fill board
  Application.ProcessMessages;
  for X := 1 to BoardSizeX do
    for Y := 1 to BoardSizeY do
      DrawBrick(X, Y, (X + Y) mod 7 + 1);
  //Update menu
  mniNew.Enabled := True;
  mniPause.Enabled := False;
  mniAbort.Enabled := False;
  //Highscore?
  for X := 1 to 10 do
  begin
    if (Score > HSscore[X]) then
    begin
      //Get name
      WinnerName := InputBox('You''re Winner!', 'You placed #' + IntToStr(X) + ' with your score of ' + IntToStr(Score) + '.' + slinebreak + 'Enter your name:', HSname[1]);
      //Shift high scores downwards; If placed 10, skip as we'll simply overwrite last score
      if X < 10 then
        for Y := 10 downto X + 1 do
        begin
          HSname[Y] := HSname[Y - 1];
          HSscore[Y] := HSscore[Y - 1];
          HSlines[Y] := HSlines[Y - 1];
        end;
      //Set new high score
      HSname[X] := WinnerName;
      HSscore[X] := Score;
      HSlines[X] := Lines;
      //Save high scores to INI file
      myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'SliTris.ini');
      for Y := 1 to 10 do
      begin
        myINI.WriteString('HighScores', 'Name' + IntToStr(Y), HSname[Y]);
        myINI.WriteInteger('HighScores', 'Score' + IntToStr(Y), HSscore[Y]);
        myINI.WriteInteger('HighScores', 'Lines' + IntToStr(Y), HSlines[Y]);
      end;
      //Close INI file
      myINI.Free;
      //Exit so that we only get 1 high score!
      Exit;
    end;
  end;
end;

procedure TForm1.DrawShape(ShapeNum, ShapeRotation, X, Y: Word); {X,Y = 1..20 } { Shape Rotation = 1..4 }
var
  X1, Y1: Byte;
begin
  for X1 := 1 to 4 do
    for Y1 := 1 to 4 do
      if Shape[ShapeNum].Def[ShapeRotation, y1, x1] = True then
        Form1.Canvas.Draw((X1 + X - 2) * BrickSize, (Y1 + Y - 2) * BrickSize, Shape[ShapeNum].P^);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  myINI: TINIFile;
  i: Byte;
begin
  //Initialise shapes
  New(BlankPic);
  BlankPic^ := ImageBlank.Picture.Bitmap;
  Shape[1].Def := Shape1;
  Shape[2].Def := Shape2;
  Shape[3].Def := Shape3;
  Shape[4].Def := Shape4;
  Shape[5].Def := Shape5;
  Shape[6].Def := Shape6;
  Shape[7].Def := Shape7;
  New(Shape[1].P);
  Shape[1].P^ := Image1.Picture.Bitmap;
  New(Shape[2].P);
  Shape[2].P^ := Image2.Picture.Bitmap;
  New(Shape[3].P);
  Shape[3].P^ := Image3.Picture.Bitmap;
  New(Shape[4].P);
  Shape[4].P^ := Image4.Picture.Bitmap;
  New(Shape[5].P);
  Shape[5].P^ := Image5.Picture.Bitmap;
  New(Shape[6].P);
  Shape[6].P^ := Image6.Picture.Bitmap;
  New(Shape[7].P);
  Shape[7].P^ := Image7.Picture.Bitmap;
  //Prepare Next image properties
  imgNext.Canvas.Pen.Style := psSolid;
  imgNext.Canvas.Pen.Color := clWhite;
  EndGame := True;
  //Initialise options from INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'SliTris.ini');
  OptHeight := myINI.ReadInteger('Settings', 'Starting_Height', 0);
  OptDensity := myINI.ReadInteger('Settings', 'Starting_Density', 1);
  OptLvlChg := myINI.ReadInteger('Settings', 'Level_Change', 10);
  OptSpeed := myINI.ReadInteger('Settings', 'Speed', 5);
  OptNext := myINI.ReadBool('Settings', 'Show_Next', True);
  for i := 1 to 10 do
  begin
    HSname[i] := myINI.ReadString('HighScores', 'Name' + IntToStr(i), 'Nobody');
    HSscore[i] := myINI.ReadInteger('HighScores', 'Score' + IntToStr(i), (11 - i) * 100);
    HSlines[i] := myINI.ReadInteger('HighScores', 'Lines' + IntToStr(i), (11 - i) * 2);
  end;
  myINI.Free;
end;

procedure TForm1.MovePieceDown;
var
  X, Y: Byte;
begin
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if (Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True) then
        DrawBrick(CurShape.X + X - 1, CurShape.Y + Y - 1, 0);
  Inc(CurShape.Y);
  DrawShape(CurShape.ShapeNum, CurShape.ShapeRot, CurShape.X, CurShape.Y);
end;

procedure TForm1.DrawScore; // and next shape
var
  TmpRot, TmpShape, X, Y: Word;
  DRect: TRect;
begin
  //Draw score on Blended Bitmap  (The background)
  lblScore.Caption := IntToStr(Score);
  lblLines.Caption := IntToStr(Lines);
  lblLevel.Caption := IntToStr(Level);
  // Draw the next shape!
  TmpShape := CurShape.ShapeNum;
  CurShape.ShapeNum := NextShape;
  TmpRot := CurShape.ShapeRot;
  CurShape.ShapeRot := 1;
  //Clear image box of previous shape
  DRect := Rect(0, 0, imgNext.Width, imgNext.Height);
  imgNext.Canvas.Rectangle(DRect);
  //Draw new shape
  if (OptNext = True) then
    for X := 1 to 4 do
      for Y := 1 to 4 do
        if Shape[NextShape].Def[1, Y, X] = True then
          imgNext.Canvas.Draw((X - 1) * BrickSize, (Y - 1) * BrickSize, Shape[NextShape].P^);
  CurShape.ShapeNum := TmpShape;
  CurShape.ShapeRot := TmpRot;
  //Update statistics
  case CurShape.ShapeNum of
    1:
      lblStat1.Caption := IntToStr(StrToInt(lblStat1.Caption) + 1);
    2:
      lblStat2.Caption := IntToStr(StrToInt(lblStat2.Caption) + 1);
    3:
      lblStat3.Caption := IntToStr(StrToInt(lblStat3.Caption) + 1);
    4:
      lblStat4.Caption := IntToStr(StrToInt(lblStat4.Caption) + 1);
    5:
      lblStat5.Caption := IntToStr(StrToInt(lblStat5.Caption) + 1);
    6:
      lblStat6.Caption := IntToStr(StrToInt(lblStat6.Caption) + 1);
    7:
      lblStat7.Caption := IntToStr(StrToInt(lblStat7.Caption) + 1);
  end;
end;

procedure TForm1.MovePieceLeft;
var
  X, Y: Byte;
begin
  //Is there anything on the board where a square needs to be?
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if (Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True) and (Brick[CurShape.X + X - 2, CurShape.Y + Y - 1] > 0) then
        Exit; //Yes: exit
  //Arrived here: it's ok to move left
  //Clear piece from current position
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True then
        DrawBrick(X + CurShape.X - 1, Y + CurShape.Y - 1, 0);
  //Decrease X position
  Dec(CurShape.X);
  //Draw piece in new position
  DrawShape(CurShape.ShapeNum, CurShape.ShapeRot, CurShape.X, CurShape.Y);
end;

procedure TForm1.MovePieceRight;
var
  X, Y: Byte;
begin
  //Is there anything on the board where a square needs to be?
  for X := 4 downto 1 do //Starting from right will detect collision in fewer loops!
    for Y := 1 to 4 do
      if (Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True) and (Brick[CurShape.X + X, CurShape.Y + Y - 1] > 0) then
        Exit; //Yes: exit
  //Arrived here: it's ok to move left
  //Clear piece from current position
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True then
        DrawBrick(X + CurShape.X - 1, Y + CurShape.Y - 1, 0);
  //Decrease X position
  Inc(CurShape.X);
  //Draw piece in new position
  DrawShape(CurShape.ShapeNum, CurShape.ShapeRot, CurShape.X, CurShape.Y);
end;

procedure TForm1.RotatePiece(Clockwise: Boolean);
var
  X, Y, NewRot: Byte;
begin
  //Determine new rotation index
  NewRot := CurShape.ShapeRot;
  if Clockwise then
  begin //CW
    if NewRot = 1 then
      NewRot := 4
    else
      Dec(NewRot);
  end
  else
  begin //CCW
    if NewRot = 4 then
      NewRot := 1
    else
      Inc(NewRot);
  end;
  //Is there anything on the board where a square needs to be?
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if (Shape[CurShape.ShapeNum].Def[NewRot, Y, X] = True) and (Brick[CurShape.X + X - 1, CurShape.Y + Y - 1] > 0) then
        Exit; //Yes: exit
  //Arrived here: it's ok to rotate
  //Clear piece from current position
  for X := 1 to 4 do
    for Y := 1 to 4 do
      if Shape[CurShape.ShapeNum].Def[CurShape.ShapeRot, Y, X] = True then
        DrawBrick(X + CurShape.X - 1, Y + CurShape.Y - 1, 0);
  //Set new rotation index
  CurShape.ShapeRot := NewRot;
  //Draw piece in new position
  DrawShape(CurShape.ShapeNum, CurShape.ShapeRot, CurShape.X, CurShape.Y);
end;

procedure TForm1.TogglePause;
var
  X, Y: Byte;
begin
  Paused := not Paused;
  for Y := 1 to BoardSizeY do
    for X := 1 to BoardSizeX do
      if Paused then
        DrawBrick(X, Y, (Y mod 7) + 1)
      else
        DrawBrick(X, Y, Brick[X, Y])
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (EndGame) then
    if (Key = 32) then  //Game over and space: start new game
      NewGame
    else
      Exit; //Else ignore all key presses
  if (Paused) then
    begin
    if (Key = 19) then  //Psused and press Pause: unpause
      TogglePause;
    Exit;
    end;
  case Key of
    17, 101: //Rotate CCW (Ctrl or num 5)
      RotatePiece(False);
    16, 104: //Rotate CW (Shift or num 8)
      RotatePiece(True);
    40, 98: //Down or num 2
      if not PieceCollided then
      begin
        MovePieceDown;
        Inc(Score);
      end;
    39, 102: //Right or num 6
      MovePieceRight;
    37, 100: //Left or num 4
      MovePieceLeft;
    27: //Escape
      EndGame := True;
    19: //Pause
      TogglePause;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm1.mniNewClick(Sender: TObject);
begin
  NewGame;
end;

procedure TForm1.mniPauseClick(Sender: TObject);
begin
  TogglePause;
end;

procedure TForm1.mniAbortClick(Sender: TObject);
begin
  EndGame := True;
end;

procedure TForm1.mniExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.mniHighscoresClick(Sender: TObject);
begin
  if Form3.visible = false then
    Form3.show
  else
    Form3.hide;
end;

procedure TForm1.mniKeysClick(Sender: TObject);
begin
  ShowMessage('Left:' + #9 + #9 + 'Left or numpad 4' + sLineBreak + 'Right:' + #9 + #9 + 'Right or numpad 6' + sLineBreak + 'Down:' + #9 + #9 + 'Down or numpad 2' + sLineBreak + 'Rotate CCW:' + #9 + 'Ctrl or numpad 5' + sLineBreak + 'Rotate CW:' + #9 + 'Shift or numpad 8' + sLineBreak + 'Start new game:' + #9 + 'Space' + sLineBreak + 'Pause:' + #9 + #9 + 'Pause' + sLineBreak + 'End game:' + #9 + 'Esc');
end;

procedure TForm1.mniSettingsClick(Sender: TObject);
begin
  if Form2.visible = false then
    Form2.show
  else
    Form2.hide;
end;

end.

