unit UGame;

interface

  uses graph, UConfig, crt;
  procedure drawGame;
  procedure restart;
  function updateGame(c: char): integer;

implementation

  const WALL_CHAR = 'w';
  const BLOCK_CHAR = 'b';
  const GOAL_CHAR = 'g';
  const GOALBLOCK_CHAR = '$';
  const SPACE_CHAR = 's';
  const LEVEL_COUNT = 1;

  var levels: array[0..LEVEL_COUNT-1] of string = ('map.txt');
      arr: array[1..50, 1..50] of char;
      goals: array[1..50, 1..50] of boolean;
      width, height: integer;
      wasLevelLoaded: boolean = false;
      playeri, playerj: integer;
      waslastgoal: boolean = false;
      curLvl: integer = 0;


  procedure drawrectanglefromcoords(i,j: integer; color: word);
  begin
    setcolor(color);
    rectangle(100*(j-1) + 1, 100*(i-1) + 1,
              100*j, 100*i);
  end;

  function isPossibleMove(di, dj: integer) : boolean;
  var res: boolean = true;
  begin
    if arr[playeri+di, playerj+dj] = WALL_CHAR then
      res := res and false;
    if (arr[playeri+di, playerj+dj] = BLOCK_CHAR) then
    begin
       if (arr[playeri+di*2, playerj+dj*2] = BLOCK_CHAR) then
         res := res and false;
       if (arr[playeri+di*2, playerj+dj*2] = WALL_CHAR) then
         res := res and false;
    end;
    ispossiblemove := res;
  end;

  procedure move(di, dj: integer);
  var tmp : char;
  begin
   if ispossiblemove(di, dj) then
   begin
     if arr[playeri+di, playerj+dj] = SPACE_CHAR then
     begin
       playeri := playeri + di;
       playerj := playerj + dj;
     end;
     if (arr[playeri + di, playerj+dj]=BLOCK_CHAR) and
        (arr[playeri + di*2, playerj+dj*2]=SPACE_CHAR) then
        begin
          arr[playeri+di, playerj+dj] := SPACE_CHAR;
          arr[playeri+di*2, playerj+dj*2] := BLOCK_CHAR;
          playeri := playeri+di;
          playerj := playerj+dj;
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

  procedure uploadMap;
  var f: text;
      c: char;
      i, j: integer;
      path: string;
  begin
    path := levels[curLvl];
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
        //read(f, arr[i, j]);
        goals[i, j] := false;
        arr[i, j] := SPACE_CHAR;
        read(f, c);
        if (c = GOAL_CHAR) or
           (c = GOALBLOCK_CHAR) then goals[i, j] := true;
        if c = WALL_CHAR then arr[i, j] := c;
        if (c = GOALBLOCK_CHAR) or
           (c = BLOCK_CHAR) then arr[i, j] := BLOCK_CHAR;
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
      uploadMap;
    end;
    cleardevice;
    for i := 1 to height do
      for j := 1 to width do
      begin
        case arr[i, j] of
          WALL_CHAR: drawrectanglefromcoords(i, j, brown);
          BLOCK_CHAR: drawrectanglefromcoords(i, j, white);
          GOAL_CHAR: drawrectanglefromcoords(i, j,red);
          GOALBLOCK_CHAR: drawrectanglefromcoords(i, j,green);
          SPACE_CHAR: drawrectanglefromcoords(i, j, black);
        end;
        if goals[i,j] then drawrectanglefromcoords(i, j, red);
        if (goals[i,j]) and
           (arr[i,j] = BLOCK_CHAR) then drawrectanglefromcoords(i, j, green);

      end;
    drawrectanglefromcoords(playeri, playerj, blue);
  end;

  function isWon: boolean;
  var i, j: integer;
      res: boolean;
  begin
    res := true;
    for i := 1 to height do
      for j := 1 to width do
        if (arr[i, j] = BLOCK_CHAR) and (not goals[i, j]) then
        begin
          res := false;
          break;
        end;
    isWon := res;
  end;


  function updateGame(c: char): integer;
  var res: integer;
  begin
    if not wasLevelLoaded then
    begin
      wasLevelLoaded := true;
      uploadMap;
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
    if iswon then 
    begin
      drawGame;
      delay(500);
      curLvl := (curLvl + 1) mod LEVEL_COUNT;
      uploadMap;
    end;
  end;

  procedure restart;
  begin
    uploadMap;
  end;

end.
