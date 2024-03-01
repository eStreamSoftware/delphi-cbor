unit cbor;

interface

uses
  System.SysUtils, System.Generics.Collections, Winapi.Windows, numbers, System.Math;

const
  Map = 5;

type
  TCborDataType = (cborUnsigned = 0, cborSigned = 1, cborByteString = 2, cborUTF8 = 3, cborArray = 4, cborMap = 5, cborSemantic = 6, cborSpecial = 7);

  TCborSemanticTag = (standardDateTime = 0, EpochDateTime = 1, positiveBigNum = 2, negativeBigNum = 3, decimal = 4, bigFloat = 5);

  TCborDataItem = record
  private
    aIndex: Integer;
    aIsIndefiniteLength: Boolean;
    aSize: UInt64;   // Number of items for array and map
    aTotalByteLength: UInt64;
    aExtendedCount: UInt64;
  public
    aValue: string;
    aType: TCborDataType;
    aTypes: TArray<TCborDataType>;
  end;

  TCborItem_TBytes = record
  private
    aIndex: Integer;
    aIsIndefiniteLength: Boolean;
    aSize: UInt64;   // Number of items for array and map
    aTotalByteLength: UInt64;
    aExtendedCount: UInt64;
  public
    aValue: TBytes;
    aType: TCborDataType;
  end;

  TCborMapData = record
    bKey: Variant;
    bValue: Variant;
  end;

  TCborMap = TArray<TCborMapData>;  // invalid variant type conversion

  TCbor_UInt64 = record
    aIsIndefiniteLength: Boolean;
    aValue: UInt64;
    aType: TCborDataType;
    constructor Create(V: UInt64; IsIL: Boolean; T: TCborDataType);
//    function EncodeUInt64: TBytes;
    class operator Implicit(cbor: TCborDataItem): TCbor_UInt64;   // means i need to do the decoding here?
    class operator Implicit(a: TCbor_UInt64): TCborDataItem;      // and do the encoding here?
    class operator Implicit(a: TCbor_UInt64): TCborItem_TBytes;
    class operator Implicit(cbor: TCborItem_TBytes): TCbor_UInt64;
  end;

  TCbor_Int64 = record
    aValue: Int64;
    aType: TCborDataType;
    aIsIndefiniteLength: Boolean;
    constructor Create(V: Int64; IsIL: Boolean; T: TCborDataType);
//    function EncodeInt64: TBytes;
    class operator Implicit(cbor: TCborDataItem): TCbor_Int64;
    class operator Implicit(a: TCbor_Int64): TCborDataItem;
    class operator Implicit(cbor: TCborItem_TBytes): TCbor_Int64;
    class operator Implicit(a: TCbor_Int64): TCborItem_TBytes;
  end;

  TCbor_ByteString = record
    aValue: TArray<string>;
    aType: TCborDataType;
    aIsIndefiniteLength: Boolean;
    constructor Create(V: TArray<string>; IsIL: Boolean; T: TCborDataType);
    class operator Implicit(cbor: TCborItem_TBytes): TCbor_ByteString;
    class operator Implicit(a: TCbor_ByteString): TCborItem_TBytes;
  end;

  TCbor_UTF8 = record
    aValue: TArray<string>;
    aType: TCborDataType;
    aIsIndefiniteLength: Boolean;
//    function EncodeUTF8: TBytes;
    constructor Create(V: TArray<string>; IsIL: Boolean; T: TCborDataType);
    class operator Implicit(cbor: TCborDataItem): TCbor_UTF8;
    class operator Implicit(a: TCbor_UTF8): TCborDataItem;
    class operator Implicit(a: TCbor_UTF8): TCborItem_TBytes;
    class operator Implicit(cbor: TCborItem_TBytes): TCbor_UTF8;
  end;

  TCbor_Array = record
  public
    aValue: TArray<TCborItem_TBytes>;
    aType: TCborDataType;
    aIsIndefiniteLength: Boolean;
    function EncodeArray: TBytes;
    class operator Implicit(cbor: TCborDataItem): TCbor_Array;
    class operator Implicit(a: TCbor_Array): TCborDataItem;
    class operator Implicit(a: TCbor_Array): TCborItem_TBytes;
  end;

  TCbor_Map = record
    aValue: TPair<TCborItem_TBytes, TCborItem_TBytes>;
    aType: TCborDataType;
    aIsIndefiniteLength: Boolean;
    class operator Implicit(cbor: TCborDataItem): TCbor_Map;
    class operator Implicit(a: TCbor_Map): TCborDataItem;
    class operator Implicit(a: TCbor_Map): TCborItem_TBytes;
  end;

  // array -> array of tcbordataitem

  // map -> array of tpair<tcbordataitem, tcbordataitem>

  TCbor = record
  private
    FData: TBytes;
    FIndex: Integer;
    FIsIndefiniteLength: Boolean;
    function GetLittleEndian(Index, Count: Cardinal): UInt64;
  public
    constructor Create(aValue: TBytes);
    function AsArray: TCbor_Array;
    function AsByteString: TCbor_ByteString;
    function AsInt64: TCbor_Int64;
    function AsMap: TCborMap;
    function AsSemantic: Variant;
    function AsSemanticBigNum: string;
    function AsUTF8: TCbor_UTF8;
    function AsUInt64: TCbor_UInt64;
    function DataItemSize: UInt64;
    function DataType: TCborDataType;
    function DecodeBasedOnDataType: TCborItem_TBytes;
    function ExtendedCount: UInt64;
    function Next: Boolean;
    procedure Reset;
    class operator Implicit(Value: TBytes): TCbor;
  end;

function UInt64ToTBytes(V: UInt64): TBytes;
function Encode_uInt64(V: TCbor_UInt64): TBytes;
function Encode_int64(V: TCbor_Int64): TBytes;
function Encode_byteString(V: TCbor_ByteString): TBytes;
function Encode_utf8(V: TCbor_UTF8): TBytes;

implementation

constructor TCbor.Create(aValue: TBytes);   // TBytes Index starts from 0
begin
  Reset;  // FIndex := -1
  FData := Copy(aValue, 0, Length(aValue));
end;

function TCbor.AsArray: TCbor_Array;
begin
  var tempResult := TArray<TCborItem_TBytes>.Create();
  var s := DataItemSize;
  Result.aType := DataType;

  if not FIsIndefiniteLength then begin
    Result.aIsIndefiniteLength := False;
    var e := ExtendedCount;
    Inc(FIndex, 1 + e);
    var c := s - 2 - e;
    for var i := 0 to c do
    begin
      tempResult := tempResult + [DecodeBasedOnDataType];
    end;
  end else begin
    Result.aIsIndefiniteLength := True;   // to store data for future encoding
    FIsIndefiniteLength := False;     // act as switch to prevent infinite loop
    Inc(FIndex, 1);
    while not ((DataItemSize = $FF) and (DataType = cborSpecial)) do begin
      tempResult := tempResult + [DecodeBasedOnDataType];
    end;
  end;
  Result.aValue := tempResult;
end;

function TCbor.AsByteString: TCbor_ByteString;
begin
  var s := DataItemSize;
  Result.aType := DataType;
  Result.aValue := TArray<string>.Create();
  if FIsIndefiniteLength then begin
    Result.aIsIndefiniteLength := True;
    FIsIndefiniteLength := False;
    Inc(FIndex, 1);
    while FData[FIndex] <> $FF do begin
      if (DataType = cborByteString) then begin
        Result.aValue := Result.aValue + AsByteString.aValue;
        next;
      end
      else raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
    end;
  end
  else begin
//    Result := TEncoding.ANSI.GetString(FData, FIndex + ExtendedCount + 1, s - ExtendedCount - 1);
    Result.aIsIndefiniteLength := False;
    SetLength(Result.aValue, 1);
    SetString(Result.aValue[0], PAnsiChar(NativeUInt(Pointer(FData)) + FIndex + ExtendedCount + 1), s - ExtendedCount - 1);
  end;
end;

function TCbor.AsSemantic: Variant;
begin
  var tag := TCborSemanticTag(DataItemSize);
  Inc(FIndex);
  case tag of
  standardDateTime: begin  
    // Result := ByteString
  end;
  PositiveBigNum: begin
    Result := AsSemanticBigNum;
  end;
  end;
end;

function TCbor.AsInt64: TCbor_Int64;
begin
  Result.aType := DataType;
  Result.aValue := -1 - AsUInt64.aValue;
end;

function TCbor.AsSemanticBigNum: string;
begin
  // split into binary first
  var s := DataItemSize;
  var e := ExtendedCount;

  for var i := s-e-1 downto 1 do begin
    var byteStr := FData[FIndex+e+i];
    OutputDebugString(PChar(byteStr));
  end;
end;

function TCbor.AsMap: TCborMap;
begin
  Result := TCborMap.Create();
  var s := DataItemSize;

  if not FIsIndefiniteLength then begin
    var e := ExtendedCount;
    Inc(FIndex, 1 + e);
    var c := s - 2 - e;
    for var i := 0 to c do
    begin
      var a : TCborMapData;
      a.bKey := DecodeBasedOnDataType.aValue;
      a.bValue := DecodeBasedOnDataType.aValue;
      Result := Result + [a];
    end;
  end else begin
    FIsIndefiniteLength := false;
    Inc(FIndex, 1);
    while not ((DataItemSize = $FF) and (DataType = cborSpecial)) do begin
      var a : TCborMapData;
      a.bKey := DecodeBasedOnDataType.aValue;
      a.bValue := DecodeBasedOnDataType.aValue;
      Result := Result + [a];
    end;
  end;
end;

function TCbor.AsUTF8: TCbor_UTF8;
begin
  var s := DataItemSize;
  Result.aType := DataType;
  Result.aValue := TArray<string>.Create();
  if FIsIndefiniteLength then begin
    Result.aIsIndefiniteLength := true;
    Inc(FIndex, 1);
    FIsIndefiniteLength := False;
    while FData[FIndex] <> $FF do begin
      if (DataType = cborUTF8) then begin
        Result.aValue := Result.aValue + AsUTF8.aValue;
        next;
      end
      else raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
    end;
  end
  else begin
    Result.aIsIndefiniteLength := False;
    Result.aValue := [TEncoding.UTF8.GetString(FData, FIndex + ExtendedCount + 1, s - ExtendedCount - 1)];
  end;
end;

function TCbor.AsUInt64: TCbor_UInt64;
begin
  var s := DataItemSize;
  Result.aType := DataType;
  if s = 1 then
    Result.aValue := FData[FIndex] and $1F  // 000 11111, to get the last 5 bits
  else
    Result.aValue := GetLittleEndian(FIndex + 1, s - 1);     //  FIndex+1 -> start from the byte after the header byte, s-1 -> deduct the header byte
end;

function TCbor.DataItemSize: UInt64;
begin
  Result := 1;           // for the first byte (header byte)
  var i := FData[FIndex] and $1F;    // Convert the first 3 bits to 0 to get the value of count
  case DataType of
    cborUnsigned, cborSigned: begin
      Inc(Result, ExtendedCount);  // + how many extended count
    end;
    cborByteString, cborUTF8, cborArray, cborMap: begin
      if i <= 23 then
        Inc(Result, i)
      else if i = 31 then
        FIsIndefiniteLength := True
      else
         Inc(Result, GetLittleEndian(FIndex + 1, ExtendedCount) + ExtendedCount); // little endian return no. of bytes for payload, hence added with the extended count in header bytes to get total no. of bytes
    end;
    cborSemantic: begin
      Result := i;      
    end;
    cborSpecial: begin
      if i = 31 then Result := 1
      //else
      // TODO: other special cases
    end
    else
      raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
  end;
end;

function TCbor.DataType: TCborDataType;
begin
  Result := TCborDataType(FData[FIndex] shr 5);  // because last 5 bits is short count, we only need the first three bits to determine data type
end;

function TCbor.DecodeBasedOnDataType: TCborItem_TBytes;
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
    cborMap: begin
      var m : Variant := AsMap;
//      Result := m;
    end;
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

function TCbor.GetLittleEndian(Index, Count: Cardinal): UInt64;  // change to descending order
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

function Encode_uInt64(V: TCbor_UInt64): TBytes;
begin 
  Result := TBytes.Create();    

  if V.aValue <= 23 then
    Result := [(Ord(V.aType) shl 5) or (V.aValue and $1F)]
  else begin
    var data := UInt64ToTBytes(V.aValue);
    var count := 24 + Round(Log2(Length(data)));
    Result := [(Ord(V.aType) shl 5) or (count and $1F)] + data;
  end;
end;

function Encode_int64(V: TCbor_Int64): TBytes;
begin
  Result := Encode_uint64(TCbor_UInt64.Create(-1-V.aValue, V.aIsIndefiniteLength, V.aType));
end;

function Encode_byteString(V: TCbor_ByteString): TBytes;
begin
  var data := TBytes.Create();

  var i: string;
  for i in V.aValue do begin
    var b := BytesOf(i);
    if Length(b) <= 23 then
      data := data + [(Ord(V.aType) shl 5) or (Length(b) and $1F)] + b
    else begin
      var lengthData := UInt64ToTBytes(Length(b));
      var count := 24 + Round(Log2(Length(UInt64ToTBytes(Length(b)))));
      data := data + [(Ord(V.aType) shl 5) or (count and $1F)] + lengthData + b;
    end;
  end;

  if V.aIsIndefiniteLength then
    Result := [(Ord(V.aType) shl 5) or (31 and $1F)] + data + [$FF]
  else
    Result := data;
end;

function Encode_utf8(V: TCbor_UTF8): TBytes;
begin
  var data := TBytes.Create();

  var i: string;
  for i in V.aValue do begin
    var b := TEncoding.UTF8.GetBytes(i);
    if Length(b) <= 23 then
      data := data + [(Ord(V.aType) shl 5) or (Length(b) and $1F)] + b
    else begin
      var lengthData := UInt64ToTBytes(Length(b));
      var count := 24 + Round(Log2(Length(UInt64ToTBytes(Length(b)))));
      data := data + [(Ord(V.aType) shl 5) or (count and $1F)] + lengthData + b;
    end;
  end;

  if V.aIsIndefiniteLength then
    Result := [(Ord(V.aType) shl 5) or (31 and $1F)] + data + [$FF]
  else
    Result := data;
end;

{ TCbor_UInt64 }

constructor TCbor_UInt64.Create(V: UInt64; IsIL: Boolean; T: TCborDataType);
begin
  aValue := V;
  aIsIndefiniteLength:= IsIL;
  aType := T;
end;

class operator TCbor_UInt64.Implicit(a: TCbor_UInt64): TCborDataItem;
begin
  Result.aType := a.aType;
  Result.aValue := a.aValue.ToString;
end;

class operator TCbor_UInt64.Implicit(cbor: TCborDataItem): TCbor_UInt64;
begin
//  Result.aValue := TCbor.Create(cbor.aValue).AsUInt64;
//  OutputDebugString(PChar(Result.aValue));

  Result.aType := cbor.aType;
  Result.aValue := StrToUInt64(cbor.aValue);
end;

class operator TCbor_UInt64.Implicit(a: TCbor_UInt64): TCborItem_TBytes;
begin
  Result.aValue := Encode_uint64(a);
  Result.aIsIndefiniteLength := a.aIsIndefiniteLength;
  Result.aType := a.aType;
end;

class operator TCbor_UInt64.Implicit(cbor: TCborItem_TBytes): TCbor_UInt64;
begin
  var d := TCbor.Create(cbor.aValue);
  if d.Next then
    Result := d.AsUInt64;
  Result.aIsIndefiniteLength := false;
end;

{ TCbor_Int64 }

constructor TCbor_Int64.Create(V: Int64; IsIL: Boolean; T: TCborDataType);
begin
  aValue := V;
  aIsIndefiniteLength := IsIL;
  aType := T;
end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): TCborDataItem;
begin
  Result.aType := a.aType;
  Result.aValue := a.aValue.ToString;
end;

class operator TCbor_Int64.Implicit(cbor: TCborDataItem): TCbor_Int64;
begin
  Result.aType := cbor.aType;
  Result.aValue := StrToInt64(cbor.aValue);
end;

//function TCbor_Int64.EncodeInt64: TBytes;
//begin
//  Result := TBytes.Create();
//  var data := UInt64ToTBytes(-1-aValue);
//
//  var count := 0;
//  if aIsIndefiniteLength then
//    count := 31
//  else begin
//    if -1-aValue <= 23 then
//      count := aValue
//    else
//      count := 24 + Round(Log2(Length(data)));
//  end;
//  Result := [(Ord(aType) shl 5) or (count and $1F)] + data;
//
//  if aIsIndefiniteLength then
//    Result := Result + [$FF];
//end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): TCborItem_TBytes;
begin
  Result.aValue := Encode_int64(a);
  Result.aType := a.aType;
  Result.aIsIndefiniteLength := a.aIsIndefiniteLength;
end;

class operator TCbor_Int64.Implicit(cbor: TCborItem_TBytes): TCbor_Int64;
begin
  var d := TCbor.Create(cbor.aValue);
  if d.Next then
    Result := d.AsInt64;
  Result.aIsIndefiniteLength := False;
end;

{ TCbor_ByteString }

constructor TCbor_ByteString.Create(V: TArray<string>; IsIL: Boolean; T: TCborDataType);
begin
  aValue := V;
  aIsIndefiniteLength := IsIL;
  aType := T;
end;

class operator TCbor_ByteString.Implicit(cbor: TCborItem_TBytes): TCbor_ByteString;
begin
  var d := TCbor.Create(cbor.aValue);
  if d.Next then
    Result := d.AsByteString;
end;

class operator TCbor_ByteString.Implicit(a: TCbor_ByteString): TCborItem_TBytes;
begin
  Result.aValue := Encode_ByteString(a);
  Result.aType := a.aType;
  Result.aIsIndefiniteLength := a.aIsIndefiniteLength;
end;

{ TCbor_UTF8 }

constructor TCbor_UTF8.Create(V: TArray<string>; IsIL: Boolean;
  T: TCborDataType);
begin
  aValue := V;
  aIsIndefiniteLength := IsIL;
  aType := T;
end;

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): TCborDataItem;
begin
  Result.aType := a.aType;
//  Result.aValue := a.aValue;
end;

class operator TCbor_UTF8.Implicit(cbor: TCborDataItem): TCbor_UTF8;
begin
  Result.aType := cbor.aType;
//  Result.aValue := cbor.aValue;
end;

//function TCbor_UTF8.EncodeUTF8: TBytes;
//begin
//  var data := TBytes.Create();
//
//  var i: string;
//  for i in aValue do begin
//    var b := TEncoding.UTF8.GetBytes(i);
//    if Length(b) <= 23 then
//      data := data + [(Ord(aType) shl 5) or (Length(b) and $1F)] + b
//    else begin
//      var lengthData := UInt64ToTBytes(Length(b));
//      var count := 24 + Round(Log2(Length(UInt64ToTBytes(Length(b)))));
//      data := data + [(Ord(aType) shl 5) or (count and $1F)] + lengthData + b;
//    end;
//  end;
//
//  if aIsIndefiniteLength then
//    Result := [(Ord(aType) shl 5) or (31 and $1F)] + data + [$FF]
//  else
//    Result := data;
//end;

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): TCborItem_TBytes;
begin
  Result.aValue := Encode_utf8(a);
  Result.aType := a.aType;
  Result.aIsIndefiniteLength := a.aIsIndefiniteLength;
end;

class operator TCbor_UTF8.Implicit(cbor: TCborItem_TBytes): TCbor_UTF8;
begin
  var d := TCbor.Create(cbor.aValue);
  if d.Next then
    Result := d.AsUTF8;
end;

{ TCbor_Array }

function TCbor_Array.EncodeArray: TBytes;
begin
  Result := TBytes.Create();
  for var i := 0 to Length(aValue)-1 do begin
    case aValue[i].aType of
    cborUnsigned: Result := Result + Encode_uint64(aValue[i]);
    cborSigned: Result := Result + Encode_int64(aValue[i]);
    cborByteString: Result := Result + Encode_ByteString(aValue[i]);
    cborUTF8: Result := Result + Encode_utf8(aValue[i]);
    end;
  end;

  if aIsIndefiniteLength then 
    Result := [(Ord(aType) shl 5) or (31 and $1F)] + Result + [$FF]
  else begin
    if Length(aValue) <= 23 then
      Result := [(Ord(aType) shl 5) or (Length(aValue) and $1F)] + Result
    else begin
      var lengthData := UInt64ToTBytes(Length(aValue));
      Result := [(Ord(aType) shl 5) or (Round(Log2(Length(lengthData))) and $1F)] + lengthData + Result;
    end;
  end;
end;

class operator TCbor_Array.Implicit(a: TCbor_Array): TCborDataItem;
begin

end;

class operator TCbor_Array.Implicit(cbor: TCborDataItem): TCbor_Array;
begin

end;

class operator TCbor_Array.Implicit(a: TCbor_Array): TCborItem_TBytes;
begin
  
end;

{ TCbor_Map }

class operator TCbor_Map.Implicit(cbor: TCborDataItem): TCbor_Map;
begin

end;

class operator TCbor_Map.Implicit(a: TCbor_Map): TCborDataItem;
begin

end;

class operator TCbor_Map.Implicit(a: TCbor_Map): TCborItem_TBytes;
begin

end;

end.
