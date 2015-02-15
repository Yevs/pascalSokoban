unit UManager;

interface

  uses graph, UGameState, UConfig,
       UMainMenu, UHelpScreen, UAboutScreen,
       UGame, crt;

  procedure draw;
  function update(c:char):integer;
  procedure init;

implementation

  procedure draw;
  var state: integer;
  begin
    state := getstate;
    case state of
      GAME_STATE:
        begin
          drawgame;
        end;
      MAIN_MENU_STATE:
        begin
          drawmainmenu;
        end;
      HELP_STATE:
        begin
          drawhelpscreen;
        end;
      ABOUT_STATE:
        drawaboutscreen;
    end;
  end;

  function update(c: char):integer;
  var state, res: integer;
  begin
    res := 0;
    state := getstate;
    case state of
      GAME_STATE:
        begin
          res := updateGame(c);
        end;
      MAIN_MENU_STATE:
        begin
          res := updateMainMenu(c);
        end;
      HELP_STATE:
        begin
          res := updateHelpScreen(c);
        end;
      ABOUT_STATE:
        res := updateaboutscreen(c);
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
        MAIN_MENU_EXIT:
          begin
            shutdown;
            break;
          end;
        MAIN_MENU_HELP:
          begin
            pushState(HELP_STATE);
            draw;
          end;
        MAIN_MENU_ABOUT:
          begin
            pushState(ABOUT_STATE);
            draw;
          end;
        MAIN_MENU_PLAY:
          begin
            pushState(GAME_STATE);
            draw;
          end;
        HELP_SCREEN_EXIT:
          begin
            delstate;
            draw;
          end;
        ABOUT_SCREEN_EXIT:
          begin
            delstate;
            draw;
          end;
        GAME_REDRAW:
          draw;
      end;
    until false;
  end;



end.
