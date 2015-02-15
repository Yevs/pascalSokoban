unit UGame;

interface

  uses graph, UConfig, crt;
  procedure drawGame;
  function updateGame(c: char): integer;


implementation

  const WALL_CHAR = 'w';
  const BLOCK_CHAR = 'b';
  const GOAL_CHAR = 'g';
  const GOALBLOCK_CHAR = '$';
  const SPACE_CHAR = 's';

  var arr: array[1..50, 1..50] of char;
      width, height: integer;
      wasLevelLoaded: boolean = false;
      playeri, playerj: integer;
      waslastgoal: booelan = false;

  procedure drawrectanglefromcoords(i,j: integer; color: word);
  begin
    setcolor(color);
    rectangle(100*(j-1) + 1, 100*(i-1) + 1,
              100*j, 100*i);
  end;

  procedure move(di, dj: integer);
  begin
    if arr[playeri + di, playerj + dj] = SPACE_CHAR then
    begin
      waslastgoal := false;
      arr[playeri, playerj] := SPACE_CHAR;
      playeri := playeri + di;
          playerj := playerj + dj;
    end
    else
    begin
      if arr[playeri + di, playerj + dj] = GOAL_CHAR then
      begin
        waslastgoal := true;
        arr[playeri, playerj] := SPACE_CHAR;
        playeri := playeri + di;
        playerj := playerj + dj;
      end
      else
        begin
        if arr[playeri + di, playerj + dj] = BLOCK_CHAR then
        begin
          if arr[playeri + 2 * di, playerj + 2 * dj] = SPACE_CHAR then
          begin
            waslastgoal := false;
            arr[playeri + 2 * di, playerj + 2 * dj] := BLOCK_CHAR;
            arr[playeri + di, playerj + dj] := SPACE_CHAR;
            playeri := playeri + di;
            playerj := playerj + dj;
          end;
          if arr[playeri + 2 * di, playerj + 2 * dj] = GOAL_CHAR then
          begin
            waslastgoal := false;
            arr[playeri + 2 * di, playerj + 2 * dj] := GOALBLOCK_CHAR;
            arr[playeri + di, playerj + dj] := SPACE_CHAR;
            playeri := playeri + di;
            playerj := playerj + dj;
          end;
        end;
        if arr[playeri + di, playerj + dj] = GOALBLOCK_CHAR then
        begin
          if arr[playeri + 2 * di, playerj + 2 * dj] = SPACE_CHAR then
          begin
            arr[playeri + 2 * di, playerj + 2 * dj] := BLOCK_CHAR;
            arr[playeri + di, playerj + dj] := GOAL_CHAR;
            playeri := playeri + di;
            playerj := playerj + dj;
          end;
          if arr[playeri + 2 * di, playerj + 2 * dj] = GOAL_CHAR then
          begin
            arr[playeri + 2 * di, playerj + 2 * dj] := GOALBLOCK_CHAR;
            arr[playeri + di, playerj + dj] := GOAL_CHAR;
            playeri := playeri + di;
            playerj := playerj + dj;
          end;
        end;
      end;
    end;
  end;

    procedure moveUp;
  begin
    move(-1, 0);
  end;

  procedure moveLeft;
  begin
    move(0, -1);
  end;

  procedure moveRight;
  begin
    move(0, 1);
  end;

  procedure moveDown;
  begin
    move(1, 0);
  end;

  procedure uploadMap(path: string);
  var f: text;
      c: char;
      i, j: integer;
  begin
    assign(f, path);
    reset(f);
    read(f, height);
    read(f, width);
    read(f, playeri);
    read(f, playerj);
    readln(f);
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        read(f, arr[i, j]);
      end;
      readln(f);
    end;
    close(f);
  end;

  procedure drawGame;
  var i, j: integer;
  begin
    if not wasLevelLoaded then
    begin
      wasLevelLoaded := true;
      uploadMap('map.txt');
    end;
    cleardevice;
    for i := 1 to height do
      for j := 1 to width do
        case arr[i, j] of
          WALL_CHAR: drawrectanglefromcoords(i, j, brown);
          BLOCK_CHAR: drawrectanglefromcoords(i, j, white);
          GOAL_CHAR: drawrectanglefromcoords(i, j,red);
          GOALBLOCK_CHAR: drawrectanglefromcoords(i, j,green);
          SPACE_CHAR: drawrectanglefromcoords(i, j, black);
        end;
    drawrectanglefromcoords(playeri, playerj, blue);
  end;

  function updateGame(c: char): integer;
  var res: integer;
  begin
    if not wasLevelLoaded then
    begin
      wasLevelLoaded := true;
      uploadMap('map.txt');
    end;
    res := 0;
    if c = #0 then
    begin
      c := readkey;
      res := updateGame(c);
    end
    else
    begin
      case c of
        #72:
          begin
            moveUp;
            res := GAME_REDRAW;
          end;
        #75:
          begin
            moveLeft;
            res := GAME_REDRAW;
          end;
        #77:
          begin
            moveRight;
            res := GAME_REDRAW;
          end;
        #80:
          begin
            moveDown;
            res := GAME_REDRAW;
          end;
        #27:
            res := GAME_PAUSE;
      end;
    end;
    updateGame := res;
  end;



  function isWon: boolean;
  var i, j: integer;
      res: boolean;
  begin
    res := true;
    for i := 1 to height do
      for j := 1 to width do
        if arr[i, j] = BLOCK_CHAR then
        begin
          res := false;
          break;
        end;
    isWon := res;
  end;



end.
