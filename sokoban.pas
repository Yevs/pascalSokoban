program sokoban;

uses graph, umanager, crt;

var gd, gm: integer;
    c: char;

begin
  gd := detect;
  gm := 0;
  initgraph(gd, gm, '');
  closegraph;
  setgraphmode(m640x480);
  init;
  closegraph;
end.
