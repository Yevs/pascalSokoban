program sokoban;

uses graph, umanager, crt;

var gd, gm: integer;
    c: char;

begin
  gd := detect;
  gm := 0;
  //setgraphmode(m800x600);
  initgraph(gd, gm, '');
  closegraph;
  setgraphmode(m800x600);
  init;
  closegraph;
end.
