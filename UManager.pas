unit UManager;

interface

  uses graph, UGameState, UConfig,
       UMainMenu, UHelpScreen, UAboutScreen,
       UGame, UPauseMenu, crt;

  procedure draw;
  function update(c:char):integer;
  procedure init;

implementation

  var curpage: integer = 0;

  procedure draw;
  var state: integer;
  begin
    //setactivepage((curpage + 1) mod 2);
    //cleardevice;
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
      PAUSE_STATE:
        drawpausemenu;
    end;
  //delay(1000);
    //setvisualpage((curpage + 1) mod 2);
    //curpage := (curpage + 1) mod 2
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
      PAUSE_STATE:
        res := updatePauseMenu(c);
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
        PAUSE_MENU_EXIT:
          begin
            delstate;
            draw;
          end;
        GAME_PAUSE:
          begin
            pushstate(PAUSE_STATE);
            draw;
          end;
        PAUSE_MENU_RESTART:
          begin
            delstate;
            restart;
            draw;
          end;
        PAUSE_MENU_TO_MAIN:
          begin
            delstate;
            delstate;
            draw;
          end;
      end;
    until false;
  end;



end.
