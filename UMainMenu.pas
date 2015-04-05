unit UMainMenu;

interface

  uses graph, UConfig, crt, UGame;

  const elements: array[1..4] of string =
     ('play', 'help', 'about', 'exit');
  const ELEMENTS_SIZE = 4;

  procedure drawMainMenu;
  function updateMainMenu(c: char): integer;

implementation

 var selected: integer = 1;

 procedure drawMainMenu;
 const x1 = 250;
 const x2 = 389;
 var y, i: integer;
 begin
   cleardevice;
   setcolor(white);
   settextjustify(centertext, centertext);
   y := 100;
   for i := 0 to ELEMENTS_SIZE - 1 do
   begin
     if i + 1 = selected then setcolor(blue);
     rectangle(x1, 100 + 50*i + 20*i,
               x2, 100 + 50*i + 20*i + 50);
     outtextxy(320, 100 + 50*i+20*i+25, elements[i+1]);
     setcolor(white);
   end;
 end;

 function handleenter: integer;
 begin
 case selected of
   1: handleenter := MAIN_MENU_PLAY;
   2: handleenter := MAIN_MENU_HELP;
   3: handleenter := MAIN_MENU_ABOUT;
   4: handleenter := MAIN_MENU_EXIT;
 end;
 end;

 function updateMainMenu(c: char): integer;
 var res: integer;
     shoulddraw: boolean;
 begin
   shoulddraw := true;
   res := 1;
   if c = #0 then
   begin
     c := readkey;
     updatemainmenu(c);
   end
   else
   begin
     case c of
     #72:
       begin
         dec(selected);
         if selected <= 0 then selected := 1;
       end;
     #80:
       begin
         inc(selected);
         if selected > 4 then selected := 4;
       end;
     #13:
         res := handleenter;
     #27:
       begin
         res := MAIN_MENU_EXIT;
       end
       else
      shoulddraw := false;
     end;

   end;
   if shoulddraw then
     drawmainmenu;
   updateMainMenu := res;
 end;

end.
