unit UManager;

interface

  uses graph, UGameState, UConfig,
       UMainMenu, crt;

  procedure draw;
  function update(c:char):integer;
  procedure init;

implementation

  procedure draw;
  var state: integer;
  begin
    state := getstate;
    case state of
      MAIN_MENU_STATE:
        begin
          drawmainmenu;
        end;
      GAME_STATE:
       begin
       end;
    end;
  end;

  function update(c: char):integer;
  var state, res: integer;
  begin
    res := 0;
    state := getstate;
    case state of
      MAIN_MENU_STATE:
        begin
          res := updateMainMenu(c);
        end;
      GAME_STATE:
        begin
        end;
    end;
    update := res;
  end;

  procedure shutDown;
  begin
    closegraph;
    exit;
  end;

  procedure init;
  var c: char;
      res: integer;
  begin
    pushstate(MAIN_MENU_STATE);
    draw;
    repeat
      c := readkey;
      res := update(c);
      case res of
        EXIT_CODE:
          begin
            shutdown;
            break;
          end;
      end;
    until false;
  end;



end.
