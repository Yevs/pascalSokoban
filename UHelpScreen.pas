unit UHelpScreen;

interface

  uses graph, uconfig;

  procedure drawHelpScreen;
  function updateHelpScreen(c: char): integer;

implementation

  procedure drawHelpScreen;
  begin
    cleardevice;
    setcolor(white);
    settextjustify(centertext, centertext);
    outtextxy(640 div 2, 480 div 2, 'Press arrow keys to move. ' +
              'Press escape to quit.');
  end;

  function updateHelpScreen(c: char): integer;
  begin
    if c = #27 then
      updateHelpScreen := HELP_SCREEN_EXIT
    else
      updateHelpScreen := 0;
  end;

end.
