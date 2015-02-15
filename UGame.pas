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

  procedure drawrectanglefromcoords(i,j: integer; color: word);
  begin
    setcolor(color);
    rectangle(100*(j-1) + 1, 100*(i-1) + 1,
              100*j, 100*i);
  end;

    procedure moveUp;
  begin
    if arr[playeri - 1, playerj] = SPACE_CHAR then
    begin
      arr[playeri, playerj] := SPACE_CHAR;
      dec(playeri);
    end
    else
    begin
      if arr[playeri - 1, playerj] = BLOCK_CHAR then
      begin
        if arr[playeri - 2, playerj] = SPACE_CHAR then
        begin
          arr[playeri - 2, playerj] := BLOCK_CHAR;
          arr[playeri - 1, playerj] := SPACE_CHAR;
          dec(playeri);
        end;
        if arr[playeri - 2, playerj] = GOAL_CHAR then
        begin
          arr[playeri - 2, playerj] := GOALBLOCK_CHAR;
          arr[playeri - 1, playerj] := SPACE_CHAR;
          dec(playeri);
        end;
      end;
      if arr[playeri - 1, playerj] = GOALBLOCK_CHAR then
      begin
        if arr[playeri - 2, playerj] = SPACE_CHAR then
        begin
          arr[playeri - 2, playerj] := BLOCK_CHAR;
          arr[playeri - 1, playerj] := GOAL_CHAR;
          dec(playeri);
        end;
        if arr[playeri - 2, playerj] = GOAL_CHAR then
        begin
          arr[playeri - 2, playerj] := GOALBLOCK_CHAR;
          arr[playeri - 1, playerj] := GOAL_CHAR;
          dec(playeri);
        end;
      end;
    end;
  end;

  procedure moveLeft;
  begin
    if arr[playeri, playerj - 1] = SPACE_CHAR then
    begin
      arr[playeri, playerj] := SPACE_CHAR;
      dec(playerj);
    end
    else
    begin
      if arr[playeri, playerj - 1] = BLOCK_CHAR then
      begin
        if arr[playeri, playerj - 2] = SPACE_CHAR then
        begin
          arr[playeri, playerj - 2] := BLOCK_CHAR;
          arr[playeri, playerj - 1] := SPACE_CHAR;
          dec(playerj);
        end;
        if arr[playeri, playerj - 2] = GOAL_CHAR then
        begin
          arr[playeri, playerj - 2] := GOALBLOCK_CHAR;
          arr[playeri, playerj - 1] := SPACE_CHAR;
          dec(playerj);
        end;
      end;
      if arr[playeri, playerj - 1] = GOALBLOCK_CHAR then
      begin
        if arr[playeri, playerj - 2] = SPACE_CHAR then
        begin
          arr[playeri, playerj - 2] := BLOCK_CHAR;
          arr[playeri, playerj - 1] := GOAL_CHAR;
          dec(playerj);
        end;
        if arr[playeri, playerj - 2] = GOAL_CHAR then
        begin
          arr[playeri, playerj - 2] := GOALBLOCK_CHAR;
          arr[playeri, playerj - 1] := GOAL_CHAR;
          dec(playerj);
        end;
      end;
    end;
  end;

  procedure moveRight;
  begin
    if arr[playeri, playerj + 1] = SPACE_CHAR then
    begin
      arr[playeri, playerj] := SPACE_CHAR;
      inc(playerj);
    end
    else
    begin
      if arr[playeri, playerj + 1] = BLOCK_CHAR then
      begin
        if arr[playeri, playerj + 2] = SPACE_CHAR then
        begin
          arr[playeri, playerj + 2] := BLOCK_CHAR;
          arr[playeri, playerj + 1] := SPACE_CHAR;
          inc(playerj);
        end;
        if arr[playeri, playerj + 2] = GOAL_CHAR then
        begin
          arr[playeri, playerj + 2] := GOALBLOCK_CHAR;
          arr[playeri, playerj + 1] := SPACE_CHAR;
          inc(playerj);
        end;
      end;
      if arr[playeri, playerj + 1] = GOALBLOCK_CHAR then
      begin
        if arr[playeri, playerj + 2] = SPACE_CHAR then
        begin
          arr[playeri, playerj + 2] := BLOCK_CHAR;
          arr[playeri, playerj + 1] := GOAL_CHAR;
          inc(playerj);
        end;
        if arr[playeri, playerj + 2] = GOAL_CHAR then
        begin
          arr[playeri, playerj + 2] := GOALBLOCK_CHAR;
          arr[playeri, playerj + 1] := GOAL_CHAR;
          inc(playerj);
        end;
      end;
    end;
  end;

  procedure moveDown;
  begin
    if arr[playeri + 1, playerj] = SPACE_CHAR then
    begin
      arr[playeri, playerj] := SPACE_CHAR;
      inc(playeri);
    end
    else
    begin
      if arr[playeri + 1, playerj] = BLOCK_CHAR then
      begin
        if arr[playeri + 2, playerj] = SPACE_CHAR then
        begin
          arr[playeri + 2, playerj] := BLOCK_CHAR;
          arr[playeri + 1, playerj] := SPACE_CHAR;
          inc(playeri);
        end;
        if arr[playeri + 2, playerj] = GOAL_CHAR then
        begin
          arr[playeri + 2, playerj] := GOALBLOCK_CHAR;
          arr[playeri + 1, playerj] := SPACE_CHAR;
          inc(playeri);
        end;
      end;
      if arr[playeri + 1, playerj] = GOALBLOCK_CHAR then
      begin
        if arr[playeri + 2, playerj] = SPACE_CHAR then
        begin
          arr[playeri + 2, playerj] := BLOCK_CHAR;
          arr[playeri + 1, playerj] := GOAL_CHAR;
          inc(playeri);
        end;
        if arr[playeri + 2, playerj] = GOAL_CHAR then
        begin
          arr[playeri + 2, playerj] := GOALBLOCK_CHAR;
          arr[playeri + 1, playerj] := GOAL_CHAR;
          inc(playeri);
        end;
      end;
    end;
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
            updateGame := GAME_EXIT;
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
