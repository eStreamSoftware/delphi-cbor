unit cbor;

interface

uses
  System.SysUtils, System.Generics.Collections, Winapi.Windows, numbers, System.Math, data.FMTBcd;

const
  Map = 5;

type
  TCborDataType = (cborUnsigned = 0, cborSigned = 1, cborByteString = 2, cborUTF8 = 3, cborArray = 4, cborMap = 5, cborSemantic = 6, cborSpecial = 7);

  TCborSemanticTag = (standardDateTime = 0, EpochDateTime = 1, positiveBigNum = 2, negativeBigNum = 3, decimal = 4, bigFloat = 5);

  TCborItem = record
  private
    FIndex: Integer;
    FIsIndefiniteLength: Boolean;
    FValue: TBytes;
    FType: TCborDataType;
  public
    function Value: TBytes;
    function cborType: TCborDataType;
  end;

  TCbor_UInt64 = record
  private
    FIsIndefiniteLength: Boolean;
    FValue: UInt64;
    FType: TCborDataType;
  public
    constructor Create(V: UInt64; T: TCborDataType = cborUnsigned);
    function Encode_Uint64: TBytes;
    function Value: UInt64;
    function cborType: TCborDataType;
    class operator Implicit(a: TCbor_UInt64): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_UInt64;
  end;

  TCbor_Int64 = record
  private
    FValue: Int64;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
  public
    constructor Create(V: Int64);
//    constructor Create(V: Int128);
    function Encode_Int64: TBytes;
    function Value: Int64;
    function cborType: TCborDataType;
    class operator Implicit(cbor: TCborItem): TCbor_Int64;
    class operator Implicit(a: TCbor_Int64): TCborItem;
  end;

  TCbor_ByteString = record
  private
    FValue: TArray<string>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
  public
    constructor Create(V: TArray<string>);
    function Encode_ByteString: TBytes;
    function Value: TArray<string>;
    function cborType: TCborDataType;
    class operator Implicit(cbor: TCborItem): TCbor_ByteString;
    class operator Implicit(a: TCbor_ByteString): TCborItem;
  end;

  TCbor_UTF8 = record
  private
    FValue: TArray<string>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
  public
    constructor Create(V: TArray<string>);
    function Encode_UTF8: TBytes;
    function Value: TArray<string>;
    function cborType: TCborDataType;
    class operator Implicit(a: TCbor_UTF8): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_UTF8;
  end;

  TCbor_Array = record
  private
    FValue: TArray<TCborItem>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
  public
    constructor Create(V: TArray<TCborItem>; IsIL: Boolean = false);
    function Encode_Array: TBytes;
    function Value: TArray<TCborItem>;
    function cborType: TCborDataType;
    class operator Implicit(a: TCbor_Array): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_Array;
  end;

  TCbor_Map = record
  private
    FValue: TArray<TPair<TCborItem, TCborItem>>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
  public
    constructor Create(V: TArray<TPair<TCborItem, TCborItem>>; IsIL: Boolean = false);
    function Encode_Map: TBytes;
    function Value: TArray<TPair<TCborItem, TCborItem>>;
    function cborType: TCborDataType;
    class operator Implicit(a: TCbor_Map): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_Map;
  end;

  TCbor_Semantic = record

  end;

  TCbor = record
  private
    FData: TBytes;
    FIndex: Integer;
    FIsIndefiniteLength: Boolean;
    function GetLittleEndian(Index, Count: Cardinal): UInt64;
    function DecodeCbor: TCborItem;
  public
    constructor Create(aValue: TBytes);
    function AsArray: TCbor_Array;
    function AsByteString: TCbor_ByteString;
    function AsInt64: TCbor_Int64;
    function AsMap: TCbor_Map;
    function AsSemantic: Variant;
    function AsSemanticBigNum: string;
    function AsUTF8: TCbor_UTF8;
    function AsUInt64: TCbor_UInt64;
    function DataItemSize: UInt64;
    function DataType: TCborDataType;
    function ExtendedCount: UInt64;
    function Next: Boolean;
    procedure Reset;
    class operator Implicit(Value: TBytes): TCbor;
  end;

function UInt64ToTBytes(V: UInt64): TBytes;

implementation

constructor TCbor.Create(aValue: TBytes);
begin
  Reset;  // FIndex := -1
  FData := Copy(aValue, 0, Length(aValue));
end;

function TCbor.AsArray: TCbor_Array;
begin
  Result.FValue := TArray<TCborItem>.Create();
  var s := DataItemSize;
  Result.FType := DataType;

  if not FIsIndefiniteLength then begin
    if s <= 1 then Exit;
    var e := ExtendedCount;
    Inc(FIndex, 1 + e);
    var c := s - 2 - e;
    for var i := 0 to c do
    begin
      Result.FValue := Result.FValue + [DecodeCbor];
    end;
  end else begin
    Result.FIsIndefiniteLength := True;   // to store data for future encoding
    FIsIndefiniteLength := False;     // act as switch to prevent infinite loop
    Inc(FIndex, 1);
    while FData[FIndex] <> $FF do
      Result.FValue := Result.FValue + [DecodeCbor];
    next;
  end;
end;

function TCbor.AsByteString: TCbor_ByteString;
begin
  var s := DataItemSize;
  Result.FType := DataType;
  Result.FValue := TArray<string>.Create();

  if FIsIndefiniteLength then begin
    FIsIndefiniteLength := False;
    Inc(FIndex, 1);
    while FData[FIndex] <> $FF do begin
      if (DataType = cborByteString) then begin
        Result.FValue := Result.FValue + AsByteString.Value;
        next;
      end
      else raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
    end;
  end
  else begin
    SetLength(Result.FValue, 1);
    SetString(Result.FValue[0], PAnsiChar(NativeUInt(Pointer(FData)) + FIndex + ExtendedCount + 1), s - ExtendedCount - 1);
  end;

  Result.FIsIndefiniteLength := Length(Result.FValue) > 1;
end;

function TCbor.AsSemantic: Variant;
begin
  var tag := TCborSemanticTag(DataItemSize);
  Inc(FIndex);
  case tag of
  standardDateTime: ;
  PositiveBigNum:
    Result := AsSemanticBigNum;
  end;
end;

function TCbor.AsInt64: TCbor_Int64;
begin
  Result.FType := DataType;
  Result.FValue := -1 - AsUInt64.FValue;
end;

function TCbor.AsSemanticBigNum: string;
begin
  var s := DataItemSize;
  var e := ExtendedCount;
  var byteStr: string := '';
  var toAdd : TArray<string> := TArray<string>.Create();
  Result := '0';

  if ((DataType = cborByteString) or (DataType = cborUTF8)) then begin       // Should support byte string only or both byte string and UTF8 string?
    for var i := s-e-1 downto 1 do
      byteStr := ToBinary(FData[FIndex+e+i]) + byteStr;
    for var j := 1 to Length(byteStr) do
      if byteStr[j] = '1' then
        Result := Add2(Result, Pow('2', Length(byteStr)-j));
  end
  else raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
end;

function TCbor.AsMap: TCbor_Map;
begin
  var s := DataItemSize;
  Result.FType := DataType;
  Result.FValue := TArray<TPair<TCborItem, TCborItem>>.Create();

  if not FIsIndefiniteLength then begin
    Result.FIsIndefiniteLength := False;
    var e := ExtendedCount;
    Inc(FIndex, 1 + e);
    SetLength(Result.FValue, s - e - 1);
    for var i := 0 to s - 2 - e do begin
      var Key := DecodeCbor;
      var Value := DecodeCbor;
      Result.FValue[i] := TPair<TCborItem, TCborItem>.Create(Key, Value);
    end;
  end else begin
    Result.FIsIndefiniteLength := True;
    FIsIndefiniteLength := false;
    Inc(FIndex, 1);
    while FData[FIndex] <> $FF do begin
      var Key := DecodeCbor;
      var Value := DecodeCbor;
      Result.FValue := Result.FValue + [TPair<TCborItem, TCborItem>.Create(Key, Value)];
    end;
  end;
end;

function TCbor.AsUTF8: TCbor_UTF8;
begin
  var s := DataItemSize;
  Result.FType := DataType;
  Result.FValue := TArray<string>.Create();
  if FIsIndefiniteLength then begin
    Inc(FIndex);
    FIsIndefiniteLength := False;
    while FData[FIndex] <> $FF do begin
      if (DataType = cborUTF8) then begin
        Result.FValue := Result.FValue + AsUTF8.FValue;
        next;
      end
      else raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
    end;
  end
  else
    Result.FValue := [TEncoding.UTF8.GetString(FData, FIndex + ExtendedCount + 1, s - ExtendedCount - 1)];

  Result.FIsIndefiniteLength := Length(Result.FValue) > 1;
end;

function TCbor.AsUInt64: TCbor_UInt64;
begin
  var s := DataItemSize;
  Result.FType := DataType;
  if s = 1 then
    Result.FValue := FData[FIndex] and $1F
  else
    Result.FValue := GetLittleEndian(FIndex + 1, s - 1);
end;

function TCbor.DataItemSize: UInt64;
begin
  Result := 1;
  var i := FData[FIndex] and $1F;
  case DataType of
    cborUnsigned, cborSigned: begin
      Inc(Result, ExtendedCount);
    end;
    cborByteString, cborUTF8, cborArray, cborMap: begin
      if i <= 23 then
        Inc(Result, i)
      else if i = 31 then
        FIsIndefiniteLength := True
      else
         Inc(Result, GetLittleEndian(FIndex + 1, ExtendedCount) + ExtendedCount);
    end;
    cborSemantic: begin
      Result := i;
    end;
    cborSpecial: begin
      if i = 31 then Result := 1
      // TODO: other special cases
    end
    else
      raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
  end;
end;

function TCbor.DataType: TCborDataType;
begin
  Result := TCborDataType(FData[FIndex] shr 5);
end;

function TCbor.DecodeCbor: TCborItem;
begin
  case DataType of
    cborUnsigned: begin
      Result := AsUInt64;
      Next;
    end;
    cborSigned: begin
      Result := AsInt64;
      Next;
    end;
    cborByteString: begin
      Result := AsByteString;
      Next;
    end;
    cborUTF8: begin
      Result := AsUTF8;
      Next;
    end;
    cborArray: Result := AsArray;
    cborMap: Result := AsMap;
  end;
end;

function TCbor.ExtendedCount: UInt64;
begin
  var A := TArray<Byte>.Create(0, 1, 2, 4, 8);
  var i := FData[FIndex] and $1F;
  if i <= 23 then i := 23;
  Result := A[i - 23];
end;

function TCbor.Next: Boolean;
begin
  if FIndex = -1 then
    FIndex := 0
  else if FIndex < Length(FData) then
    Inc(FIndex, DataItemSize);
  Result := FIndex < Length(FData);
end;

procedure TCbor.Reset;
begin
  FIndex := -1;
  FIsIndefiniteLength := False;
end;

function TCbor.GetLittleEndian(Index, Count: Cardinal): UInt64;
begin
  var temp := '';
  var R := TArray<Byte>.Create(0, 0, 0, 0, 0, 0, 0, 0);
  var j := 0;
  for var i := Index + Count - 1 downto Index do begin    // Index = FIndex + 1, Count = dataItemSize-1
    R[j] := FData[i];
    temp := temp + ToBinary(R[j]);
    Inc(j);
  end;
  Move(R[0], Result, Length(R));
end;

class operator TCbor.Implicit(Value: TBytes): TCbor;
begin
  Result := TCbor.Create(Value);
end;

function UInt64ToTBytes(V: UInt64): TBytes;
begin
  Result := TBytes.Create(0, 0, 0, 0, 0, 0, 0, 0);
  for var i := 0 to Length(Result)-1 do begin
    Result[i] := (V and $FF00000000000000) shr 56;
    V := (V and $00FFFFFFFFFFFFFF) shl 8;
  end;
  while Result[0] = 0 do Delete(Result, 0, 1);

  case Length(Result) of
  3: Result := [$00] + Result;
  5, 6, 7:
    for var i := 1 to 8-Length(Result) do
      Result := [$00] + Result;
  end;
end;

{ TCbor_UInt64 }

constructor TCbor_UInt64.Create(V: UInt64; T: TCborDataType = cborUnsigned);
begin
  FValue := V;
  FIsIndefiniteLength:= false;
  FType := T;
end;

function TCbor_UInt64.Encode_Uint64: TBytes;
begin
  Result := TBytes.Create();

  if FValue <= 23 then
    Result := [(Ord(FType) shl 5) or (FValue and $1F)]
  else begin
    var data := UInt64ToTBytes(FValue);
    var count := 24 + Round(Log2(Length(data)));
    Result := [(Ord(FType) shl 5) or (count and $1F)] + data;
  end;
end;

function TCbor_UInt64.Value: UInt64;
begin
  Result := FValue;
end;

function TCbor_UInt64.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_UInt64.Implicit(a: TCbor_UInt64): TCborItem;
begin
  Result.FValue := a.Encode_uint64;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
  Result.FType := a.FType;
end;

class operator TCbor_UInt64.Implicit(cbor: TCborItem): TCbor_UInt64;
begin
  var d := TCbor.Create(cbor.Value);
  if d.Next then
    Result := d.AsUInt64;
  Result.FIsIndefiniteLength := false;
end;

{ TCbor_Int64 }


constructor TCbor_Int64.Create(V: Int64);
begin
  FValue := V;
  FIsIndefiniteLength := false;
  FType := cborSigned;
end;

function TCbor_Int64.Encode_Int64: TBytes;
begin
  Result := TCbor_UInt64.Create((-1 - FValue), FType).Encode_Uint64;
end;

function TCbor_Int64.Value: Int64;
begin
  Result := FValue;
end;

function TCbor_Int64.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): TCborItem;
begin
  Result.FValue := a.Encode_int64;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_Int64.Implicit(cbor: TCborItem): TCbor_Int64;
begin
  var d := TCbor.Create(cbor.Value);
  if d.Next then
    Result := d.AsInt64;
  Result.FIsIndefiniteLength := False;
end;

{ TCbor_ByteString }

constructor TCbor_ByteString.Create(V: TArray<string>);
begin
  FValue := V;
  FType := cborByteString;
  if Length(V) > 1 then
    FIsIndefiniteLength := true
  else
    FIsIndefiniteLength := false;
end;

function TCbor_ByteString.Encode_ByteString: TBytes;
begin
   Result := TBytes.Create();

  var i: string;
  for i in FValue do begin
    var b := BytesOf(i);
    if Length(b) <= 23 then
      Result := Result + [(Ord(FType) shl 5) or (Length(b) and $1F)] + b
    else begin
      var lengthData := UInt64ToTBytes(Length(b));
      var count := 24 + Round(Log2(Length(UInt64ToTBytes(Length(b)))));
      Result := Result + [(Ord(FType) shl 5) or (count and $1F)] + lengthData + b;
    end;
  end;

  if FIsIndefiniteLength then
    Result := [(Ord(FType) shl 5) or (31 and $1F)] + Result + [$FF];
end;

function TCbor_ByteString.Value: TArray<string>;
begin
  Result := FValue;
end;

function TCbor_ByteString.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_ByteString.Implicit(cbor: TCborItem): TCbor_ByteString;
begin
  var d := TCbor.Create(cbor.Value);
  if d.Next then
    Result := d.AsByteString;
end;

class operator TCbor_ByteString.Implicit(a: TCbor_ByteString): TCborItem;
begin
  Result.FValue := a.Encode_ByteString;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;


{ TCbor_UTF8 }

constructor TCbor_UTF8.Create(V: TArray<string>);
begin
  FValue := V;
  FType := cborUTF8;
  if Length(V) > 1 then
    FIsIndefiniteLength := true
  else
    FIsIndefiniteLength := false;
end;

function TCbor_UTF8.Encode_UTF8: TBytes;
begin
  Result := TBytes.Create();

  var i: string;
  for i in FValue do begin
    var b := TEncoding.UTF8.GetBytes(i);
    if Length(b) <= 23 then
      Result := Result + [(Ord(FType) shl 5) or (Length(b) and $1F)] + b
    else begin
      var lengthData := UInt64ToTBytes(Length(b));
      var count := 24 + Round(Log2(Length(UInt64ToTBytes(Length(b)))));
      Result := Result + [(Ord(FType) shl 5) or (count and $1F)] + lengthData + b;
    end;
  end;

  if FIsIndefiniteLength then
    Result := [(Ord(FType) shl 5) or (31 and $1F)] + Result + [$FF];
end;

function TCbor_UTF8.Value: TArray<string>;
begin
  Result := FValue;
end;

function TCbor_UTF8.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): TCborItem;
begin
  Result.FValue := a.Encode_utf8;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_UTF8.Implicit(cbor: TCborItem): TCbor_UTF8;
begin
  var d := TCbor.Create(cbor.FValue);
  if d.Next then
    Result := d.AsUTF8;
end;

{ TCbor_Array }

constructor TCbor_Array.Create(V: TArray<TCborItem>; IsIL: Boolean = false);
begin
  FValue := V;
  FIsIndefiniteLength := IsIL;
  FType := cborArray;
end;

function TCbor_Array.Encode_Array: TBytes;
begin
  Result := TBytes.Create();
  for var i := 0 to Length(FValue)-1 do
    Result := Result + FValue[i].Value;

  if FIsIndefiniteLength then
    Result := [(Ord(FType) shl 5) or (31 and $1F)] + Result + [$FF]
  else begin
    if Length(FValue) <= 23 then
      Result := [(Ord(FType) shl 5) or (Length(FValue) and $1F)] + Result
    else begin
      var lengthData := UInt64ToTBytes(Length(FValue));
      Result := [(Ord(FType) shl 5) or (Round(Log2(Length(lengthData))) and $1F)] + lengthData + Result;
    end;
  end;
end;

function TCbor_Array.Value: TArray<TCborItem>;
begin
  Result := FValue;
end;

function TCbor_Array.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_Array.Implicit(a: TCbor_Array): TCborItem;
begin
  Result.FValue := a.Encode_Array;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_Array.Implicit(cbor: TCborItem): TCbor_Array;
begin
  var a := TCbor(cbor.FValue);
  if a.Next then
    Result := a.AsArray;
end;

{ TCbor_Map }

constructor TCbor_Map.Create(
  V: TArray<TPair<TCborItem, TCborItem>>; IsIL: Boolean = false);
begin
  FValue := V;
  FIsIndefiniteLength := IsIL;
  FType := cborMap;
end;

function TCbor_Map.Encode_Map: TBytes;
begin
  Result := TBytes.Create();
  for var i := 0 to Length(FValue)-1 do
    Result := Result + FValue[i].Key.Value + FValue[i].Value.Value;

  if FIsIndefiniteLength then
    Result := [(Ord(FType) shl 5) or (31 and $1F)] + Result + [$FF]
  else begin
    if Length(FValue) <= 23 then
      Result := [(Ord(FType) shl 5) or (Length(FValue) and $1F)] + Result
    else begin
      var lengthData := UInt64ToTBytes(Length(FValue));
      Result := [(Ord(FType) shl 5) or (Round(Log2(Length(lengthData))) and $1F)] + lengthData + Result;
    end;
  end;
end;

function TCbor_Map.Value: TArray<TPair<TCborItem, TCborItem>>;
begin
  Result := FValue;
end;

function TCbor_Map.cborType: TCborDataType;
begin
  Result := FType;
end;

class operator TCbor_Map.Implicit(a: TCbor_Map): TCborItem;
begin
  Result.FValue := a.Encode_map;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_Map.Implicit(cbor: TCborItem): TCbor_Map;
begin
  var a := TCbor(cbor.FValue);
  if a.Next then
    Result := a.AsMap;
end;

{ TCborItem }

function TCborItem.Value: TBytes;
begin
  Result := FValue;
end;

function TCborItem.cborType: TCborDataType;
begin
  Result := FType;
end;

end.
