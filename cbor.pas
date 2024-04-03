unit cbor;

interface

uses
  System.SysUtils, System.Generics.Collections, Winapi.Windows, System.Math, data.FMTBcd, System.Variants, System.NetEncoding;

const
  Map = 5;

type
  TCborDataType = (cborUnsigned = 0, cborSigned = 1, cborByteString = 2, cborUTF8 = 3, cborArray = 4, cborMap = 5, cborSemantic = 6, cborSpecial = 7);

  TCborSemanticTag = (standardDateTime = 0, EpochDateTime = 1, positiveBigNum = 2, negativeBigNum = 3, decimal = 4, bigFloat = 5, toBase64url = 21,
                      encodedCbor = 24, URI = 32, base64url = 33, base64 = 34, regex = 35, mime = 36, selfDescribed = 55799);

  TCborSpecialTag = (cborFalse = 20, cborTrue = 21, cborNull = 22, cborUndefined = 23, cbor16bitFloat = 25, cbor32bitFloat = 26, cbor64bitFloat = 27, cborBreak = 31);

  TCborItem = record
  private
    FIsIndefiniteLength: Boolean;
    FValue: TBytes;
    FType: TCborDataType;
  public
    function Value: TBytes;
    function cborType: TCborDataType;
    class operator Implicit(a: TCborItem): UInt64;  // ambiguous overloaded call
    class operator Implicit(a: TCborItem): Int64;   // ambiguous overloaded call
//    class operator Implicit(a: TCborItem): string;
  end;

  TCbor_UInt64 = record
  private
    FValue: UInt64;
    FType: TCborDataType;
  public
    constructor Create(V: UInt64; T: TCborDataType = cborUnsigned);
    function Encode_Uint64: TBytes;
    function Value: UInt64;
    function cborType: TCborDataType;
    class operator Implicit(a: TCbor_UInt64): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_UInt64;
    class operator Implicit(a: TCbor_UInt64): UInt64;
  end;

  TCbor_Int64 = record
  private
    FValue: Int64;
    FType: TCborDataType;
  public
    constructor Create(V: Int64);
//    constructor Create(V: Int128);
    function Encode_Int64: TBytes;
    function Value: Int64;
    function cborType: TCborDataType;
    class operator Implicit(cbor: TCborItem): TCbor_Int64;
    class operator Implicit(a: TCbor_Int64): TCborItem;
    class operator Implicit(a: TCbor_Int64): Int64;
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
    class operator Implicit(a: TCbor_ByteString): string;
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
    class operator Implicit(a: TCbor_UTF8): string;
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
  private
    FValue: TBytes; // TBD
    FType: TCborDataType;
    FTag: TCborSemanticTag;
  public
    constructor Create(V: TBytes; T: TCborSemanticTag);
    function Encode_Semantic: TBytes;
    function Value: TBytes;
    function cborType: TCborDataType;
    function Tag: TCborSemanticTag;
    class operator Implicit(a: TCbor_Semantic): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_Semantic;
    class operator Implicit(a: TCbor_Semantic): string;
    class operator Implicit(a: TCbor_Semantic): TBcd;
    class operator Implicit(a: TCbor_Semantic): UInt64;
    class operator Implicit(a: TCbor_Semantic): Int64;
  end;

  TCbor_Special = record
  private
    FValue: TBytes;
    FType: TCborDataType;
    FTag: TCborSpecialTag;
  public
    constructor Create(V: TBytes; T: TCborSpecialTag);
    function Value: TBytes;
    class operator Implicit(a: TCbor_Special): TCborItem;
    class operator Implicit(cbor: TCborItem): TCbor_Special;
    class operator Implicit(a: TCbor_Special): Boolean;
    class operator Implicit(a: TCbor_Special): Variant;
    class operator Implicit(a: TCbor_Special): TBcd;
    class operator Implicit(a: TCbor_Special): string;
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
    function AsSemantic: TCbor_Semantic;
    function AsSpecial: TCbor_Special;
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
function toBinary(dec: Integer): string;
function pow(base, exp: TBcd): TBcd;

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

function TCbor.AsSemantic: TCbor_Semantic;
begin
  Result.FType := DataType;

  if FData[FIndex] and $1F <= 23 then
    Result.FTag := TCborSemanticTag(FData[FIndex] and $1F)
  else
    Result.FTag := TCborSemanticTag(GetLittleEndian(FIndex+1, ExtendedCount));

//  var temp := TCbor.Create(Copy(FData, 1 + ExtendedCount, )
//  var totalSize := 1 + ExtendedCount +

  Result.FValue := FData; // need to calculate length later
                          // same for as special function

  // calculate here or calculate in the data item size function?

//  Inc(FIndex);
//  case DataType of
//  cborByteString: begin
//    Result.FValue := AsByteString;
//  end;
//  cborUTF8: Result.FValue := AsUTF8;

//  end;
end;

function TCbor.AsInt64: TCbor_Int64;
begin
  Result.FType := DataType;
  Result.FValue := -1 - AsUInt64.FValue;
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

function TCbor.AsSpecial: TCbor_Special;
begin
  Result.FValue := FData;
  Result.FType := DataType;

  if ExtendedCount = 1 then
    Result.FTag := TCborSpecialTag(FData[FIndex+1])
  else
    Result.FTag := TCborSpecialTag(FData[FIndex] and $1F);
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
//      Result := i;
      var n := FIndex;

    end;
    cborSpecial: begin
      if (i = 31) or (i <= 23) then
        Result := 1
      else if (i = 24) or (i = 25) or (i = 26) or (i = 27) then
        Inc(Result, ExtendedCount)
      else
        raise Exception.CreateFmt('Unknown additional information', [i]);
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

function toBinary(dec: Integer): string;
begin
  if dec = 0 then Exit('00000000');
  Result := '';
  while dec > 0 do begin
    Result := Chr(Ord('0') + (dec and 1)) + Result;
    dec := dec shr 1;
  end;
  while Length(Result) mod 8 <> 0 do
    Result := '0' + Result;
end;

{ TCbor_UInt64 }

constructor TCbor_UInt64.Create(V: UInt64; T: TCborDataType = cborUnsigned);
begin
  FValue := V;
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
  Result.FIsIndefiniteLength := false;
  Result.FType := a.FType;
end;

class operator TCbor_UInt64.Implicit(cbor: TCborItem): TCbor_UInt64;
begin
  var d := TCbor.Create(cbor.Value);
  if d.Next then
    Result := d.AsUInt64;
end;

class operator TCbor_UInt64.Implicit(a: TCbor_UInt64): UInt64;
begin
  Result := a.Value;
end;

{ TCbor_Int64 }


constructor TCbor_Int64.Create(V: Int64);
begin
  FValue := V;
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
  Result.FIsIndefiniteLength := false;
end;

class operator TCbor_Int64.Implicit(cbor: TCborItem): TCbor_Int64;
begin
  var d := TCbor.Create(cbor.Value);
  if d.Next then
    Result := d.AsInt64;
end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): Int64;
begin
  Result := a.Value;
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


class operator TCbor_ByteString.Implicit(a: TCbor_ByteString): string;
begin
  if not a.FIsIndefiniteLength then
    Exit(a.Value[0]);

  Result := '(_ ';
  for var i := 0 to Length(a.Value) - 2 do
    Result := Result + a.Value[i] + ', ';

  Result := Result + a.Value[Length(a.Value) - 1] + ')';
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

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): string;
begin
  if not a.FIsIndefiniteLength then
    Exit(a.Value[0]);

  Result := '(';
  for var i := 0 to Length(a.Value) - 2 do
    Result := Result + a.Value[i] + ', ';

  Result := Result + a.Value[Length(a.Value) - 1] + ')';
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

class operator TCborItem.Implicit(a: TCborItem): UInt64;
begin
  var c := TCbor.Create(a.FValue);
  if c.Next and (a.cborType = cborUnsigned) then
    Result := c.AsUInt64.Value;
end;

//class operator TCborItem.Implicit(a: TCborItem): string;
//begin
//  var c := TCbor.Create(a.FValue);
//  if c.Next then
//    if a.cborType = cborByteString then
//      Result := c.AsByteString
//    else
//      Result := c.AsUTF8;
//end;

class operator TCborItem.Implicit(a: TCborItem): Int64;
begin
  var c := TCbor.Create(a.FValue);
  if c.Next and (a.cborType = cborSigned) then
    Result := c.AsInt64.Value;
end;

function TCborItem.Value: TBytes;
begin
  Result := FValue;
end;

function TCborItem.cborType: TCborDataType;
begin
  Result := FType;
end;

{ TCbor_Semantic }

constructor TCbor_Semantic.Create(V: TBytes; T: TCborSemanticTag);
begin
  FValue := V;
  FTag := T;
end;

function TCbor_Semantic.Encode_Semantic: TBytes;
begin
  Result:= FValue;
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): TBcd;
begin
  // for decimal and big float
  var base : Integer;
  if a.FTag = decimal then
    base := 10
  else if a.FTag = bigFloat then
    base := 2
  else raise Exception.CreateFmt('Unsupported tag: %d', [Ord(a.FTag)]);

  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value) - 1));
  var arr : TArray<TCborItem>;
  if c.Next then arr := c.AsArray.FValue;

  var arrInt64 := TArray<Int64>.Create();
  for var i := 0 to 1 do
    if arr[i].cborType = cborUnsigned then
      arrInt64 := arrInt64 + [TCbor_UInt64(arr[i]).Value]
    else if arr[i].cborType = cborSigned then
      arrInt64 := arrInt64 + [TCbor_Int64(arr[i]).Value];

  if arrInt64[0] = 0 then
    Exit(arrInt64[1]);

  Result := arrInt64[1] * Power(base, arrInt64[0]);
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): string;
begin
  var c : TCbor;
  if (a.Value[0] and $1F) <= 23 then
    c := TCbor.Create(Copy(a.Value, 1, Length(a.Value) - 1))
  else begin
    var t := TCbor.Create(a.Value);
    if t.Next then
      c := TCbor.Create(Copy(a.Value, t.ExtendedCount + 1, Length(a.Value) - t.ExtendedCount - 1));
  end;

  if not c.Next then raise Exception.Create('No data load');

  if c.DataType = cborByteString then
    Result := c.AsByteString.Value[0]
  else if c.DataType = cborUTF8 then begin
    Result := c.AsUTF8.Value[0];
    if (a.Tag = base64url) or (a.Tag = base64) then
      Result := TBase64Encoding.Base64String.Decode(Result);
  end;
end;

function TCbor_Semantic.Value: TBytes;
begin
  Result := FValue;
end;

function TCbor_Semantic.Tag: TCborSemanticTag;
begin
  Result:= FTag;
end;

function TCbor_Semantic.cborType: TCborDataType;
begin
  Result := cborType;
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): TCborItem;
begin
  Result.FValue := a.Encode_Semantic;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := false;
end;

class operator TCbor_Semantic.Implicit(cbor: TCborItem): TCbor_Semantic;
begin
  var a := TCbor(cbor.FValue);
  if a.Next then
    Result := a.AsSemantic;
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): Int64;
begin
  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value)-1));
  if c.Next then
    Result := c.AsInt64.Value;
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): UInt64;
begin
  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value)-1));
  if c.Next then
    Result := c.AsUInt64.Value;
end;

{ TCbor_Special }

constructor TCbor_Special.Create(V: TBytes; T: TCborSpecialTag);
begin
  FValue := V;
  FTag := T;
  FType := cborSpecial;
end;

class operator TCbor_Special.Implicit(cbor: TCborItem): TCbor_Special;
begin
  var a := TCbor(cbor.FValue);
  if a.Next then
    Result := a.AsSpecial;
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): TCborItem;
begin
  Result.FValue := a.FValue;
  Result.FType := cborSpecial;
  Result.FIsIndefiniteLength := false;
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): Boolean;
begin
  if Ord(a.FTag) = 20 then
    Result := False
  else if Ord(a.FTag) = 21 then
    Result := True
  else
    raise Exception.Create('Tag unmatched.');
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): TBcd;
begin
  var BinaryStr := '';
  var strLength, exponentLength: Integer;
  var exponent: Extended := 0;
  var mantissa: TBcd := 0;

  case a.FTag of
    cbor16bitFloat: begin
      strLength := 16;
      exponentLength := 5;
    end;
    cbor32bitFloat: begin
      strLength := 32;
      exponentLength := 8;
    end;
    cbor64bitFloat: begin
      strLength := 64;
      exponentLength := 11;
    end;
  end;

  for var i := 1 to (strLength div 8) do
    BinaryStr := BinaryStr + ToBinary(a.FValue[i]);

  for var i := exponentLength+1 downto 2 do
    if BinaryStr[i] = '1' then
      exponent := exponent + Power(2, (exponentLength+1-i));
  exponent := exponent - (Power(2, (exponentLength - 1)) - 1);

  for var i := strLength downto exponentLength+2 do begin
    if BinaryStr[i] = '1' then
      mantissa := mantissa + power(2, strLength-i);
  end;

  if (exponent = Power(2, exponentLength-1)) then begin   // Check for positive/negative infinity and NaN
    if mantissa = 0 then
      if BinaryStr[1] = '0' then Exit(1.0/0.0)
      else Exit(-1.0/0.0)
    else
      Exit(0.0/0.0);
  end;
  if exponent = -1*(Power(2, exponentLength-1)-1) then begin
    if mantissa = 0 then
      if BinaryStr[1] = '0' then Exit(0)
      else Exit(-0);
    exponent := exponent + 1;
    mantissa := mantissa / Double(Pow(2, strLength-exponentLength-1));
  end else
    mantissa := 1 + mantissa / Double(Pow(2, strLength-exponentLength-1));

  var p1 := Power(2, exponent);
  var p2 := BcdToStr(Pow(2, exponent));

  var r1 := Power(2, exponent) * mantissa * Power(-1, StrToInt(BinaryStr[1]));
  var r2 := BcdToStr(Pow(2, exponent) * mantissa * Pow(-1, StrToInt(BinaryStr[1])));

  Result := Power(2, exponent) * mantissa * Power(-1, StrToInt(BinaryStr[1]));

  var rs := BcdToStr(Result);
//  if pos(FormatSettings.DecimalSeparator, BcdToStr(Result)) = 0 then
//    Result := RoundTo(Result, -1);                       // for XX.0

//  if Result.SignSpecialPlaces = 0 then begin
//    NormalizeBcd(Result, Result, Result.Precision + 1, 1);
//    Result := BcdRoundTo(Result, -1);
//  end;
end;

function pow(base, exp: TBcd): TBcd;
begin
  Result := 1;
  if exp = 0 then exit;
  var isNegative : Boolean := exp < 0;
  if exp < 0 then exp := exp * -1;
  while exp <> 0 do begin
  var s := BcdToStr(exp);
  if (StrToInt(s[Length(s)]) mod 2) = 1 then Result := Result * base;
    base := base * base;
    BcdDivide(s, 2, exp);
    NormalizeBcd(exp, exp, MaxFMTBcdDigits, 0);
  end;
  if isNegative then
    Result := 1/Result;

  // Int overflow
  // need to use int128 or tbcd
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): Variant;
begin
  if a.FTag = cborNull then Result := Null;
end;

function TCbor_Special.Value: TBytes;
begin
  Result := FValue;
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): string;
begin
  if (a.Value[0] and $1F) < 23 then
    Result := 'simple(' + IntToStr(a.Value[0] and $1F) + ')'
  else if (a.Value[0] and $1F) = 23 then
    Result := 'undefined'
  else
    Result := 'simple(' + IntToStr(a.Value[1]) + ')';
end;

end.
