unit UAboutScreen;

interface

  uses graph, uconfig;

  procedure drawAboutScreen;
  function updateAboutScreen(c: char): integer;

implementation

  procedure drawAboutScreen;
  begin
    cleardevice;
    setcolor(white);
    settextjustify(centertext, centertext);
    outtextxy(640 div 2, 480 div 2, 'This game is created by Yevhen Y.');
  end;

  function updateAboutScreen(c: char): integer;
  begin
    if c = #27 then
      updateAboutScreen := ABOUT_SCREEN_EXIT
    else
      updateAboutScreen := 0;
  end;

end.
