// Auto-generated code below aims at helping you parse
// the standard input according to the problem statement.
program Answer;
{$H+}
uses sysutils, classes, math;

// Helper to read a line and split tokens
procedure ParseIn(Inputs: TStrings) ;
var Line : string;
begin
    readln(Line);
    Inputs.Clear;
    Inputs.Delimiter := ' ';
    Inputs.DelimitedText := Line;
end;

var
    n : Int32; // the number of temperatures to analyse
    i : Int32;
    winner : Int32;
    current : Int32;
    Inputs: TStringList;
    Temps:  TStringList;
begin
    Inputs := TStringList.Create;
    ParseIn(Inputs);
    n := StrToInt(Inputs[0]);
//    readln(temps);
//    writeln(temps); 
    Temps := TStringList.Create;
    ParseIn(Temps);
    if Temps.Count = 0 then
    begin
       writeln(0); 
       exit;
    end;
    
    winner := StrToInt(Temps[0]);
    
    for i := 1 to Temps.Count-1 do begin
       //writeln(Temps[i]);
       current := StrToInt(Temps[i]);
       if ( abs(winner) > abs(current) )
          or (abs(winner) = abs(current)) and (winner < 0) then
       begin
          winner:=current;
       end;
    end;
    

    // Write an action using writeln()
    // To debug: writeln(StdErr, 'Debug messages...');

    writeln(winner);
    flush(StdErr); flush(output); // DO NOT REMOVE
end.
