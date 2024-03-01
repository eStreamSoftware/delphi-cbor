unit numbers;

interface

function Add(Values: array of string): string;
function Add2(a, b: string): string;
function Mul(a, b: string): string;
function Subt(a, b: string): string;
function IntDivide(a, b: string): string;
function Divide(a, b: string): string;
function Pow(a: string; b: Integer): string;

function Pow2(a: string): string;

function toBinary(dec: Integer): string;

var Pow2Arr : TArray<string>;

implementation

uses
  System.SysUtils;

function toBinary(dec: Integer): string;
begin
  Result := '';
  while dec > 0 do begin
    Result := Chr(Ord('0') + (dec and 1)) + Result;
    dec := dec shr 1;
  end;
  while Length(Result) mod 8 <> 0 do
    Result := '0' + Result;
end;


function RemoveZero(a: string; pos: integer): string;
begin
  while (Length(a) > 1) and (a[pos] = '0') and (a[2] <> '.') do
    Delete(a, pos, 1);
end;

function AddTwoChar(ch1, ch2: char; carry: integer): string;
begin
  Result := IntToStr((Ord(ch1) - Ord('0') + Ord(ch2) - Ord('0') + carry) mod 10);
end;

function GetCarry(ch1, ch2: char; carry: integer): integer;
begin
  Result := (Ord(ch1) - Ord('0') + Ord(ch2) - Ord('0') + carry) div 10;
end;


function Add(Values: array of string): string;
begin
  var num := Length(Values);
  if num <= 0 then Exit('0');
  var answer: string := '';

  for var i := 0 to num - 1 do
  begin
    var tempAnswer: String := '';
    var carry: Integer := 0;

    var str1: string := answer;
    var length1: Integer := Length(answer);

    var str2: string := Values[i];
    var length2: Integer := Length(Values[i]);

    while (length1 > 0) and (length2 > 0) do
    begin
      tempAnswer := AddTwoChar(str1[length1], str2[length2], carry) + tempAnswer;
      carry := GetCarry(str1[length1], str2[length2], carry);
      length1 := length1 - 1;
      length2 := length2 - 1;
    end;

    while (length1 > 0) do
    begin
      tempAnswer := AddTwoChar(str1[length1], '0', carry) + tempAnswer;
      carry := GetCarry(str1[length1], '0', carry);
      length1 := length1 - 1;
    end;

    while (length2 > 0) do
    begin
      tempAnswer := AddTwoChar(str2[length2], '0', carry) + tempAnswer;
      carry := GetCarry(str2[length2], '0', carry);
      length2 := length2 - 1;
    end;

    if carry > 0 then
      tempAnswer := '1' + tempAnswer;

    answer := tempAnswer;

  end;

  while (answer[1] = '0') and (Length(answer)>1) do
    Delete(answer, 1, 1);

  Result := answer;

end;

function Add2(a, b: string): string;
begin
    Result := '';
    var carry: Integer := 0;
    var length1: Integer := Length(a);
    var length2: Integer := Length(b);

    while (length1 > 0) and (length2 > 0) do
    begin
      Result := AddTwoChar(a[length1], b[length2], carry) + Result;
      carry := GetCarry(a[length1], b[length2], carry);
      length1 := length1 - 1;
      length2 := length2 - 1;
    end;

    while (length1 > 0) do
    begin
      Result := AddTwoChar(a[length1], '0', carry) + Result;
      carry := GetCarry(a[length1], '0', carry);
      length1 := length1 - 1;
    end;

    while (length2 > 0) do
    begin
      Result := AddTwoChar(b[length2], '0', carry) + Result;
      carry := GetCarry(b[length2], '0', carry);
      length2 := length2 - 1;
    end;

    if carry > 0 then
      Result := '1' + Result;

    while (Result[1] = '0') and (Length(Result)>1) do
      Delete(Result, 1, 1);
end;


function Mul2char(ch1, ch2: char; carry: Integer): Integer;
begin
  Result := ((Ord(ch1) - Ord('0')) * (Ord(ch2) - Ord('0')) + carry);
end;


function Mul(a, b: string): string;
begin
  var multi : integer := 0; // temp product for each a[i] * b[j]

  var multiplyProducts := TArray<string>.Create();
 // to add a new elements into the array
 // multiplyProducts := multiplyProcutts + ['123445']

  for var i := length(b) downto 1 do
  begin
    // Multiply a with each number of b[i]
    var tempAnswer : string := '';
    var carry : Integer := 0;

    for var j := length(a) downto 1 do
    begin
      // Multiply a[j] by b[i]
      multi := (Ord(a[j]) - Ord('0')) * (Ord(b[i]) - Ord('0')) + carry;
      tempAnswer := IntToStr(multi mod 10) + tempAnswer;
      carry := multi div 10;

    end;

    if carry <> 0 then
       tempAnswer := IntToStr(carry) + tempAnswer;

    for var j := length(b) downto i + 1 do
        tempAnswer := tempAnswer + '0';

    multiplyProducts := multiplyProducts + [tempAnswer];

  end;

  Result := Add(multiplyProducts);
end;

function swap(var a, b: string): boolean;
begin
  // add zero to get same length
  while Length(a) > Length(b) do
    b := '0' + b;

  while Length(b) > Length(a) do
    a := '0' + a;

  // swap if b is larger than a
  for var i := 1 to (Length(a)) do
  begin
    if b[i] > a[i] then begin
      var c := b;
      b := a;
      a := c;
      exit(true) // return true
    end else if b[i] < a[i] then
      exit(false);
  end;
  Result := false;
end;

function Subt2(a, b: string): string;
begin
  var answer : string := '';
  var borrow : integer := 0;
  var sub : integer := 0;

  for var i := Length(B) downto 1 do
  begin
  sub := (Ord(a[i]) - Ord('0')) - (Ord(b[i]) - Ord('0')) - borrow;
  if sub < 0 then begin
    borrow := 1;
    sub := (sub + 10) mod 10;
  end else
    borrow := 0;

    Result := IntToStr(sub) + Result;
  end;

  while (Result[1] = '0') and (Length(Result) > 1) do
    Delete(Result, 1, 1);

  if Length(Result) = 0 then Result := '0';

end;

function Subt(a, b: string): string;
begin
  var negative : boolean := false;
  Result := '';
  var bisLarger : boolean := false;

  if (a[1] = '-') and (b[1] = '-') then begin
     // remove negative sign
     Delete(a, 1, 1);
     Delete(b, 1, 1);

     bisLarger := swap(a, b);
     if not bisLarger then negative := true;

     Result := Subt2(a, b);

  end else if (a[1] = '-') and (b[1] <> '-') then begin
     Delete(a, 1, 1);

     bisLarger := swap(a, b);
     negative := true;

     var T := TArray<string>.Create(a, b);

     Result := Add(T);

  end else if (a[1] <> '-') and (b[1] = '-') then begin
     Delete(b, 1, 1);

     bisLarger := swap(a, b);
     negative := false;

     var T := TArray<string>.Create(a, b);

     Result := Add(T);

  end else begin
     bisLarger := swap(a, b);
     if bisLarger then negative := true;

     Result := Subt2(a, b);

  end;

  if negative and (Result <> '0')then
    Result := '-' + Result;

end;


function IntDivide(a, b: string): string;
begin
  var isNegative : boolean := false;

  if (a[1] = '-') and (b[1] = '-') then begin
     // remove negative sign
     Delete(a, 1, 1);
     Delete(b, 1, 1);

  end else if (a[1] = '-') and (b[1] <> '-') then begin
     Delete(a, 1, 1);
     isNegative := true;

  end else if (a[1] <> '-') and (b[1] = '-') then begin
     Delete(b, 1, 1);
     isNegative := true;

  end;

  while (Length(a) > 1) and (a[1] = '0') do
    Delete(a, 1, 1);
  while (Length(b) > 1) and (b[1] = '0') do
    Delete(b, 1, 1);

  if a = '0' then
    Exit('0');
  if b = '0' then
    Exit('Invalid Operation');

  var tempAns : string := '';
  var remainder : string := '';
  Result := '';

  for var i := 1 to Length(A) do
  begin
    remainder := remainder + a[i];
    tempAns := '0';

    for var j := 0 to 10 do
    begin
      var check : string := Subt(remainder, Mul(b, IntToStr(j)));
      if check[1] = '-'  then begin
        remainder := Subt(remainder, Mul(b, (Char((j-1) + Ord('0')))));
        tempAns := Char((j-1) + Ord('0'));
        break;
      end;
    end;

    Result := Result + tempAns;
  end;

  while (Result[1] = '0') and (Length(Result) > 1) do Delete(Result, 1, 1);

  while (Result[Length(Result)] = '0') and (Length(Result) > 1) do begin
    if Result[Length(Result)-1] = '.' then begin
      Delete(Result, Length(Result)-1, 2);
      Break;
    end else
      Delete(Result, Length(Result), 1);
  end;


  if (isNegative) and (Result <> '0') then
    Result := '-' + Result;

end;


function Divide(a, b: string): string;
begin
  var isNegative : boolean := false;

  if (a[1] = '-') and (b[1] = '-') then begin
     // remove negative sign
     Delete(a, 1, 1);
     Delete(b, 1, 1);

  end else if (a[1] = '-') and (b[1] <> '-') then begin
     Delete(a, 1, 1);

     isNegative := true;

  end else if (a[1] <> '-') and (b[1] = '-') then begin
     Delete(b, 1, 1);

     isNegative := true;

  end;

  RemoveZero(a, 1);
  RemoveZero(b, 1);

  if a = '0' then
    Exit('0');
  if b = '0' then
    Exit('Invalid Operation');

  var decimalA : Integer := 0;
  var decimalB : Integer := 0;
  var decimalDiff : Integer;

  // remove '.'
  for var i := Length(a) downto 1 do
    if a[i] = '.' then begin
      decimalA := Length(a) - i;
      Delete(a, i, 1);
    end;

  for var i := Length(b) downto 1 do
    if b[i] = '.' then begin
      decimalB := Length(b) - i;
      Delete(b, i, 1);
    end;

  if (decimalA > decimalB) then begin
    decimalDiff := decimalA - decimalB;
    for var i := 1 to decimalDiff do
       b := b + '0';
  end else if (decimalB > decimalA) then begin  // decimalB > decimalA or decimalA = decimalB
    decimalDiff := decimalB - decimalA;
    for var i := 1 to decimalDiff do
      a := a + '0';
  end;

  var tempAns : string := '';
  var remainder : string := '';
  Result := '';

  for var i := 1 to Length(A) do
  begin
    remainder := remainder + a[i];
    tempAns := '0';

    for var j := 0 to 10 do
    begin
      var check : string := Subt(remainder, Mul(b, IntToStr(j)));
      if check[1] = '-'  then begin
        remainder := Subt(remainder, Mul(b, (Char((j-1) + Ord('0')))));
        break;
      end else begin
        tempAns := Char(j + Ord('0'));
      end;
    end;

    Result := Result + tempAns;
  end;

  if remainder <> '0' then begin
    Result := Result + '.';

    var counter := 0;
    while (remainder <> '0') and (counter < 16) do begin
      remainder := remainder + '0';
      tempAns := '0';

      for var j := 0 to 10 do
      begin
        var deccheck : string := Subt(remainder, Mul(b, IntToStr(j)));
        if deccheck[1] = '-'  then begin
          remainder := Subt(remainder, Mul(b, (Char((j-1) + Ord('0')))));
          break;
        end else begin
          tempAns := Char(j + Ord('0'));
        end;
      end;

      Result := Result + tempAns;
      counter := counter + 1;
    end;
  end;

  while (Result[1] = '0') and (Result[2] <> '.') and (Length(Result) > 1) do Delete(Result, 1, 1);

  if (isNegative) and (Result <> '0') then
    Result := '-' + Result;

end;

function Pow(a: string; b: Integer): string;
begin
  // a Pow b
  Result := '1';
  if b = 0 then
    exit;

  var isNegative : Boolean := b < 0;

  while abs(b) > 0 do begin
    if abs(b) mod 2 = 1 then Result := Mul(Result, a);
    a := Mul(a, a);
    b := b div 2;
  end;

  if isNegative then
    Result := Divide('1', Result);

//  if b < 0 then begin
//    for var i := 1 to (b * (-1)) do
//      Result := Mul(Result, a);
//    Result := Divide('1', Result);
//  end else begin
//    for var i := 1 to b do
//     Result:= Mul(Result, a);
//  end;
end;

function Pow2(a: string): string;
begin
  while Length(Pow2Arr) <= a.ToInt64 do
    Pow2Arr := Pow2Arr + [Mul(Pow2Arr[Length(Pow2Arr)-1], '2')];
end;

end.
