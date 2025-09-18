unit cbor;

interface

uses
  Winapi.Windows, System.Classes, System.Generics.Collections, System.Math,
  System.NetEncoding, System.SysUtils, Data.FMTBcd,
  System.Variants;

type
  TCborDataType = (cborUnsigned = 0, cborSigned = 1, cborByteString = 2, cborUTF8 = 3, cborArray = 4, cborMap = 5, cborSemantic = 6, cborSpecial = 7);

  TCborSemanticTag = (standardDateTime = 0, EpochDateTime = 1, positiveBigNum = 2, negativeBigNum = 3, decimal = 4, bigFloat = 5, toBase64url = 21, encodedCbor = 24,
                    URI = 32, base64url = 33, base64 = 34, regex = 35, mime = 36, selfDescribed = 55799);

  TCborSpecialTag = (cborSimple, cborFalse = 20, cborTrue = 21, cborNull = 22, cborUndefined = 23, cbor16bitFloat = 25, cbor32bitFloat = 26, cbor64bitFloat = 27, cborBreak = 31);

  TCborItem = record
  private
    FIsIndefiniteLength: Boolean;
    FValue: TBytes;
    FType: TCborDataType;
    function GetValueCount: Integer;
    function GetPayload: TBytes;
    function GetPayloadCount: Integer;
  public
    class operator Implicit(a: TCborItem): Boolean;
    class operator Implicit(a: TCborItem): Extended;
    class operator Implicit(a: TCborItem): Int64;
    class operator Implicit(a: TCborItem): string;
    class operator Implicit(a: TCborItem): Variant;
    function SameAs(aCbor: TCborItem): Boolean;
    property cborType: TCborDataType read FType;
    property Value: TBytes read FValue;
    property ValueCount: Integer read GetValueCount;
    property Payload: TBytes read GetPayload;
    property PayloadCount: Integer read GetPayloadCount;
  end;

  TCbor_UInt64 = record
  private
    FValue: UInt64;
    FType: TCborDataType;
  public
    constructor Create(V: UInt64);
    class operator Implicit(a: TCbor_UInt64): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_UInt64;
    class operator Implicit(a: TCbor_UInt64): UInt64;
    function Encode_Uint64: TBytes;
    property Value: UInt64 read FValue;
    property cborType: TCborDataType read FType;
  end;

  TCbor_Int64 = record
  private
    FValue: Int64;
    FType: TCborDataType;
  public
    constructor Create(V: Int64);
    class operator Implicit(aCbor: TCborItem): TCbor_Int64;
    class operator Implicit(a: TCbor_Int64): TCborItem;
    class operator Implicit(a: TCbor_Int64): Int64;
    function Encode_Int64: TBytes;
    property Value: Int64 read FValue;
    property cborType: TCborDataType read FType;
  end;

  TCbor_ByteString = record
  private
    FValue: TArray<TBytes>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
    function GetAsString: TArray<string>;
  public
    constructor Create(V: TArray<TBytes>; aIsIndefiniteLength: Boolean = false);
    class operator Implicit(aCbor: TCborItem): TCbor_ByteString;
    class operator Implicit(a: TCbor_ByteString): TCborItem;
    class operator Implicit(a: TCbor_ByteString): string;
    function Encode_ByteString: TBytes;
    property AsString: TArray<string> read GetAsString;
    property Value: TArray<TBytes> read FValue;
    property CborType: TCborDataType read FType;
  end;

  TCbor_UTF8 = record
  private
    FValue: TArray<string>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
    function GetAsBytes: TArray<TBytes>;
  public
    constructor Create(V: TArray<string>; aIsIndefiniteLength: Boolean = false);
    class operator Implicit(a: TCbor_UTF8): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_UTF8;
    class operator Implicit(a: TCbor_UTF8): string;
    function Encode_UTF8: TBytes;
    property AsBytes: TArray<TBytes> read GetAsBytes;
    property Value: TArray<string> read FValue;
    property CborType: TCborDataType read FType;
  end;

  TCbor_Array = record
  private
    FValue: TArray<TCBorItem>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
    function GetCount: Integer;
    function GetValues(Index: Integer): TCBorItem;
  public
    constructor Create(V: TArray<TCborItem>; aIsIndefiniteLength: Boolean = false);
    class operator Implicit(a: TCbor_Array): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_Array;
    function Encode_Array: TBytes;
    property Values[Index: Integer]: TCBorItem read GetValues; default;
    property CborType: TCborDataType read FType;
    property Count: Integer read GetCount;
  end;

  TCbor_Map = record
  private
    FValue: TArray<TPair<TCborItem, TCborItem>>;
    FType: TCborDataType;
    FIsIndefiniteLength: Boolean;
    function GetCount: Integer;
    function GetValues(IndexOrName: OleVariant): TPair<TCborItem, TCborItem>;
  public
    constructor Create(V: TArray<TPair<TCborItem, TCborItem>>; aIsIndefiniteLength:
        Boolean = false);
    class operator Implicit(a: TCbor_Map): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_Map;
    function ContainsKey(aKey: String): Boolean; overload;
    function ContainsKey(aKey: Int64): Boolean; overload;
    function ContainsKey(aKey: String; out Index: Integer): Boolean; overload;
    function ContainsKey(aKey: UInt64): Boolean; overload;
    function Encode_Map: TBytes;
    function IndexOf(aKey: String): Integer;
    function ValueByKey(aKey: Int64): TCborItem; overload;
    function ValueByKey(aKey: String): TCborItem; overload;
    function ValueByKey(aKey: UInt64): TCborItem; overload;
    property CborType: TCborDataType read FType;
    property Count: Integer read GetCount;
    property Values[IndexOrName: OleVariant]: TPair<TCborItem, TCborItem> read GetValues; default;
  end;

  TCbor_Semantic = record
  private
    FValue: TBytes; 
    FType: TCborDataType;
    FTag: TCborSemanticTag;
  public
    constructor Create(V: TBytes; T: TCborSemanticTag);
    class operator Implicit(a: TCbor_Semantic): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_Semantic;
    class operator Implicit(a: TCbor_Semantic): string;
    class operator Implicit(a: TCbor_Semantic): TBcd;
    class operator Implicit(a: TCbor_Semantic): UInt64;
    class operator Implicit(a: TCbor_Semantic): Int64;
    class operator Implicit(a: TCbor_Semantic): Extended;
    function Encode_Semantic: TBytes;
    property Value: TBytes read FValue;
    property CborType: TCborDataType read FType;
    property Tag: TCborSemanticTag read FTag;
  end;

  TCbor_Special = record
  private
    FValue: TBytes;
    FType: TCborDataType;
    FTag: TCborSpecialTag;
  public
    constructor Create(V: TBytes; T: TCborSpecialTag);
    class operator Implicit(a: TCbor_Special): TCborItem;
    class operator Implicit(aCbor: TCborItem): TCbor_Special;
    class operator Implicit(a: TCbor_Special): Boolean;
    class operator Implicit(a: TCbor_Special): Variant;
    class operator Implicit(a: TCbor_Special): Extended;
    class operator Implicit(a: TCbor_Special): string;
    property Value: TBytes read FValue;
    property CborType: TCborDataType read FType;
    property Tag: TCborSpecialTag read FTag;
  end;

  TCbor = record
  const
    BreakCode = $FF;
    IndefiniteLength = 31;
    MaxShortCount = 23;
    ShortCountBit = $1F;
  private
    FData: TBytes;
    FIndex: Integer;
    function AsIndefiniteLengthBytes: TArray<TBytes>;
    function GetLittleEndian(aIndex, Count: Cardinal): UInt64;
    function DecodeCbor(var aIndex: Integer): TCborItem;
    function AsIndefiniteLengthString: TArray<string>;
    function ExtendedCount: Integer;
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
    function DataItemSize: Integer;
    function DataType: TCborDataType;
    class function Encode(aLength: UInt64; aType: TCborDataType;
        aIsIndefiniteLength: Boolean; aData: TBytes): TBytes; static;
    function Next: Boolean;
    procedure Reset;
    class operator Implicit(Value: TBytes): TCbor;
  end;

implementation

constructor TCbor.Create(aValue: TBytes);
begin
  Reset;  // FIndex := -1
  FData := Copy(aValue, 0, Length(aValue));
end;

function TCbor.AsArray: TCbor_Array;
begin
//  if Length(FData) - FIndex < DataItemSize then
//    raise Exception.CreateFmt('Out of bytes to decode. (Need at least %d bytes more)', [DataItemSize-(Length(FData) - FIndex)]);
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType = cborArray, 'Major type unmatched.');

  Result.FValue := TArray<TCborItem>.Create();
  Result.FType := DataType;
  var l := FData[FIndex] and ShortCountBit;
  var n := FIndex + 1;

  if l = IndefiniteLength then begin
    Result.FIsIndefiniteLength := True;
    while FData[n] <> BreakCode do begin
      Result.FValue := Result.FValue + [DecodeCbor(n)];
      if n >= Length(FData) then
        raise Exception.Create('Out of bytes to decode.');      // End of data before break code
    end;
  end else begin
    if ExtendedCount <> 0 then begin
      l := GetLittleEndian(FIndex + 1, ExtendedCount);
      n := n + ExtendedCount;
    end;
    SetLength(Result.FValue, l);
    for var i := 0 to l - 1 do
      Result.FValue[i] := DecodeCbor(n);
  end;
end;

function TCbor.AsByteString: TCbor_ByteString;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType =  cborByteString, 'Major type unmatched.');

  Result.FType := DataType;
  Result.FValue := TArray<TBytes>.Create();

  if (FData[FIndex] and ShortCountBit) = IndefiniteLength then begin
    Result.FIsIndefiniteLength := True;
    Result.FValue := AsIndefiniteLengthBytes;
  end
  else begin
    SetLength(Result.FValue, 1);
    Result.FValue[0] := Copy(FData, FIndex + ExtendedCount + 1, DataItemSize - ExtendedCount - 1);
  end;
end;

function TCbor.AsIndefiniteLengthBytes: TArray<TBytes>;
begin
  var n := FIndex + 1;
  while FData[n] <> BreakCode do
    if (TCborDataType(FData[n] shr 5) = DataType) then begin
      var c := TCbor.Create(Copy(FData, n, DataItemSize - 1 - n));
      c.FIndex := 0;
      if (c.FData[0] and ShortCountBit) = IndefiniteLength then begin
        var tempR := c.AsIndefiniteLengthBytes;
        var b: TBytes := [];
        for var s in tempR do
          b := b + s;
        Result := Result + [b];
      end else
        if DataType = cborByteString then
          Result := Result + c.AsByteString.FValue
        else
          Result := Result + c.AsUTF8.AsBytes;
      Inc(n, c.DataItemSize);
    end
    else raise Exception.CreateFmt('Bytes/text mismatch in streaming string: %d', [Byte(DataType)]);     // not of the appropriate major type before break code
end;

function TCbor.AsInt64: TCbor_Int64;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  
  Result.FType := DataType;
  Result.FValue := -1 - Int64(AsUInt64.FValue);
end;

function TCbor.AsMap: TCbor_Map;
var Key, Value: TCborItem;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType = cborMap, 'Major type unmatched.');
  
  Result.FValue := TArray<TPair<TCborItem, TCborItem>>.Create();
  Result.FType := DataType;
  var l := FData[FIndex] and ShortCountBit;
  var n := FIndex + 1;

  if l = IndefiniteLength then begin
    Result.FIsIndefiniteLength := True;
    while FData[n] <> BreakCode do begin
      Key := DecodeCbor(n);
      if n >= Length(FData) then raise Exception.Create('Out of bytes to decode.');     // End of data before break code
      if FData[n] = BreakCode then raise Exception.Create('Break stop code outside indefinite length item');   // Break code after "Key" (Missing "Value")

      Value := DecodeCbor(n);
      if n >= Length(FData) then raise Exception.Create('Out of bytes to decode.');     // End of data before break code

      Result.FValue := Result.FValue + [TPair<TCborItem, TCborItem>.Create(Key, Value)];
    end;
  end else begin
    if ExtendedCount <> 0 then begin
      l := GetLittleEndian(FIndex + 1, ExtendedCount);
      n := n + ExtendedCount;
    end;
    SetLength(Result.FValue, l);
    for var i := 0 to l - 1 do begin
      Key := DecodeCbor(n);
      Value := DecodeCbor(n);
      Result.FValue[i] := TPair<TCborItem, TCborItem>.Create(Key, Value);
    end;
  end;
end;

function TCbor.AsSemantic: TCbor_Semantic;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType = cborSemantic, 'Major type unmatched.');
  
  Result.FValue := Copy(FData, FIndex, DataItemSize);
  Result.FType := DataType;

  if ExtendedCount = 0 then
    Result.FTag := TCborSemanticTag(FData[FIndex] and ShortCountBit)
  else
    Result.FTag := TCborSemanticTag(GetLittleEndian(FIndex+1, ExtendedCount));
end;

function TCbor.AsSpecial: TCbor_Special;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType = cborSpecial, 'Major type unmatched.');
  
  Result.FValue := Copy(FData, FIndex, DataItemSize);
  Result.FType := DataType;

  var i := FData[FIndex] and ShortCountBit;
  if (i < 20) or (i = 24) then i := 0;
  Result.FTag := TCborSpecialTag(i);
end;

function TCbor.AsIndefiniteLengthString: TArray<string>;
begin
  var n := FIndex + 1;
  while FData[n] <> BreakCode do
    if (TCborDataType(FData[n] shr 5) = DataType) then begin
      var c := TCbor.Create(Copy(FData, n, DataItemSize - 1 - n));
      c.FIndex := 0;
      if (c.FData[0] and ShortCountBit) = IndefiniteLength then begin
        var tempR := c.AsIndefiniteLengthString;
        var strR := '';
        for var s in tempR do
          strR := strR + s;
        Result := Result + [strR];
      end else
        if DataType = cborByteString then
          Result := Result + c.AsByteString.AsString
        else
          Result := Result + c.AsUTF8.Value;
      Inc(n, c.DataItemSize);
    end
    else raise Exception.CreateFmt('Bytes/text mismatch in streaming string: %d', [Byte(DataType)]);     // not of the appropriate major type before break code
end;

function TCbor.AsUTF8: TCbor_UTF8;
begin
  Assert(Length(FData) - FIndex >= DataItemSize, 'Out of bytes to decode.');
  Assert(DataType = cborUTF8, 'Major type unmatched.');
  
  Result.FType := DataType;
  Result.FValue := TArray<string>.Create();

  if (FData[FIndex] and ShortCountBit) = IndefiniteLength then begin
    Result.FIsIndefiniteLength := True;
    Result.FValue := AsIndefiniteLengthString;
  end
  else
    Result.FValue := [TEncoding.UTF8.GetString(FData, FIndex + ExtendedCount + 1, DataItemSize - ExtendedCount - 1)];
end;

function TCbor.AsUInt64: TCbor_UInt64;
begin
  var s := DataItemSize;
  Assert(Length(FData) - FIndex >= s, 'Out of bytes to decode.');
  
  Result.FType := DataType;
  if s = 1 then
    Result.FValue := FData[FIndex] and ShortCountBit
  else
    Result.FValue := GetLittleEndian(FIndex + 1, s - 1);
end;

function TCbor.DataItemSize: Integer;
var c : TCbor;
begin
  Result := 1;
  var i := FData[FIndex] and ShortCountBit;
  var l := function(aResult, aIndex: Integer; aCbor: TCbor): Integer     // to calculate size of indefinite length cbor
  begin
    Result := aResult;
    while Result < (Length(aCbor.FData) - aIndex) do begin
      c := TCbor.Create(Copy(aCbor.FData, Result, Length(aCbor.FData) - Result));
      Assert(c.Next, 'Out of bytes to decode.');
      Inc(Result, c.DataItemSize);
      if c.FData[0] = BreakCode then
        break;
    end;
  end;

  case DataType of
    cborUnsigned, cborSigned: begin
      Inc(Result, ExtendedCount);
    end;
    cborByteString, cborUTF8: begin
      if i <= MaxShortCount then
        Inc(Result, i)
      else if i = IndefiniteLength then
        Result := l(Result, FIndex, Self)
      else
        Inc(Result, Integer(GetLittleEndian(FIndex + 1, ExtendedCount)) + ExtendedCount);
    end;
    cborArray, cborMap: begin
      if i = IndefiniteLength then
        Result := l(Result, FIndex, Self)
      else begin
        if i > MaxShortCount then
          i := GetLittleEndian(FIndex + 1, ExtendedCount);
        if DataType = cborMap then
          i := 2*i;
        Inc(Result, ExtendedCount);
        for var j := 1 to i do begin
          c := TCbor.Create(Copy(FData, Result, Length(FData) - Result));
          if not c.Next then raise Exception.CreateFmt('Out of bytes to decode. (need at least %d byte(s) more)', [i - j + 1]);
          Inc(Result, c.DataItemSize);
        end;
      end;
    end;
    cborSemantic: begin
      Inc(Result, ExtendedCount); // Size of Tag
      c := TCbor.Create(Copy(FData, FIndex + Result, Length(FData) - FIndex - Result));
      if c.Next then
        Inc(Result, c.DataItemSize);  // Size of Tag Item
    end;
    cborSpecial: begin
      if i <= 27 then
        Inc(Result, ExtendedCount)
      else if (i > 27) and (i < ShortCountBit) then
        raise Exception.CreateFmt('Unknown additional information %d', [i]);      // 28 - 30 -> unassigned
    end
    else
      raise Exception.CreateFmt('Unsupported major type: %d', [Byte(DataType)]);
  end;
end;

function TCbor.DataType: TCborDataType;
begin
  Result := TCborDataType(FData[FIndex] shr 5);
end;

function TCbor.DecodeCbor(var aIndex: Integer): TCborItem;
begin
  var c := TCbor.Create(Copy(FData, aIndex, Length(FData)-aIndex));
  c.FIndex := 0;
  case c.DataType of
    cborUnsigned: Result := c.AsUInt64;
    cborSigned: Result := c.AsInt64;
    cborByteString: Result := c.AsByteString;
    cborUTF8: Result := c.AsUTF8;
    cborArray: Result := c.AsArray;
    cborMap: Result := c.AsMap;
    cborSemantic: Result := c.AsSemantic;
    cborSpecial: Result := c.AsSpecial;
    else
      Assert(False, 'Unsupported major type');
  end;
  Inc(aIndex, c.DataItemSize);
end;

class function TCbor.Encode(aLength: UInt64; aType: TCborDataType;
    aIsIndefiniteLength: Boolean; aData: TBytes): TBytes;
begin
  var ExtendedCountInfo: TArray<Byte> := [0, 24, 25, 0, 26, 0, 0, 0, 27];

  if aIsIndefiniteLength then
    Result := [(Ord(aType) shl 5) or TCbor.ShortCountBit] + aData + [TCbor.BreakCode]
  else
    if aLength <= TCbor.MaxShortCount then
      Result := [(Ord(aType) shl 5) or aLength] + aData
    else begin
      var lengthData := TBytes.Create(0, 0, 0, 0, 0, 0, 0, 0);
      var l := aLength;
      for var i := 0 to Length(LengthData) - 1 do begin
        lengthData[i] := (l shr 56) and $FF;
        l := l shl 8;
      end;

      var i := 0;
      while lengthData[i] = 0 do Inc(i);
      if i > 0 then Delete(lengthData, 0, i);

      case Length(lengthData) of
      3: lengthData := [$00] + lengthData;
      5, 6, 7:
        for var j := 1 to 8-Length(lengthData) do
          lengthData := [$00] + lengthData;
      end;

      Result := [(Ord(aType) shl 5) or ExtendedCountInfo[Length(lengthData)]] + lengthData + aData;
    end;
end;

function TCbor.ExtendedCount: Integer;
begin
  var A := TArray<Byte>.Create(0, 1, 2, 4, 8, 0, 0, 0);
  var i := FData[FIndex] and ShortCountBit;
  if i <= MaxShortCount then i := MaxShortCount;
  Result := A[i - MaxShortCount];
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
end;

function TCbor.GetLittleEndian(aIndex, Count: Cardinal): UInt64;
begin
  var temp := '';
  var R := TArray<Byte>.Create(0, 0, 0, 0, 0, 0, 0, 0);
  var j := 0;
  for var i := aIndex + Count - 1 downto aIndex do begin    // aIndex = FIndex + 1, Count = dataItemSize-1
    R[j] := FData[i];
    Inc(j);
  end;
  Move(R[0], Result, Length(R));
end;

class operator TCbor.Implicit(Value: TBytes): TCbor;
begin
  Result := TCbor.Create(Value);
end;

{ TCbor_UInt64 }

constructor TCbor_UInt64.Create(V: UInt64);
begin
  FValue := V;
  FType := cborUnsigned;
end;

function TCbor_UInt64.Encode_Uint64: TBytes;
begin
  Result := TCbor.Encode(FValue, FType, False, []);
end;

class operator TCbor_UInt64.Implicit(a: TCbor_UInt64): TCborItem;
begin
  Result.FValue := a.Encode_uint64;
  Result.FIsIndefiniteLength := false;
  Result.FType := a.FType;
end;

class operator TCbor_UInt64.Implicit(aCbor: TCborItem): TCbor_UInt64;
begin
  var d := TCbor.Create(aCbor.Value);
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
  Result := TCbor.Encode(-1-FValue, FType, False, []);
end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): TCborItem;
begin
  Result.FValue := a.Encode_int64;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := false;
end;

class operator TCbor_Int64.Implicit(aCbor: TCborItem): TCbor_Int64;
begin
  var d := TCbor.Create(aCbor.Value);
  if d.Next then
    Result := d.AsInt64;
end;

class operator TCbor_Int64.Implicit(a: TCbor_Int64): Int64;
begin
  Result := a.Value;
end;

{ TCbor_ByteString }

constructor TCbor_ByteString.Create(V: TArray<TBytes>; aIsIndefiniteLength:
    Boolean = false);
begin
  FValue := V;
  FType := cborByteString;
  FIsIndefiniteLength := aIsIndefiniteLength;
  if (Length(V) > 1) and not FIsIndefiniteLength then
    raise Exception.Create('Length of definite-length string cannot be more than 1');
end;

function TCbor_ByteString.Encode_ByteString: TBytes;
begin
  var a := Function(aStr: TCbor_ByteString): TBytes
  begin
    for var b in aStr.FValue do
      Result := Result + TCbor.Encode(Length(b), aStr.FType, False, b);
  end;

  if FIsIndefiniteLength then
    Result := TCbor.Encode(0, FType, FIsIndefiniteLength, a(Self))
  else
    Result := a(Self);
end;

function TCbor_ByteString.GetAsString: TArray<string>;
begin
  for var b in FValue do
    Result := Result + [TEncoding.ANSI.GetString(b)];
end;

class operator TCbor_ByteString.Implicit(aCbor: TCborItem): TCbor_ByteString;
begin
  var d := TCbor.Create(aCbor.Value);
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
    Result := a.AsString[0]
  else begin
  Result := '(_ ';
    for var i := 0 to Length(a.Value) - 2 do
      Result := Result + '''' + a.AsString[i] + ''', ';

    Result := Result + '''' + a.AsString[Length(a.AsString) - 1] + ''')';
  end;
end;

{ TCbor_UTF8 }

constructor TCbor_UTF8.Create(V: TArray<string>; aIsIndefiniteLength: Boolean =
    false);
begin
  FValue := V;
  FType := cborUTF8;
  FIsIndefiniteLength := aIsIndefiniteLength;
  if (Length(V) > 1) and not FIsIndefiniteLength then
    raise Exception.Create('Length of definite-length string cannot be more than 1');
end;

function TCbor_UTF8.Encode_UTF8: TBytes;
begin
  var a := function(aStr: TCbor_UTF8): TBytes
  begin
    for var i in aStr.FValue do begin
      var b := TEncoding.UTF8.GetBytes(i);
      Result := Result + TCbor.Encode(Length(b), aStr.FType, False, b);
    end;
  end;

  if FIsIndefiniteLength then
    Result := TCbor.Encode(Length(Result), FType, FIsIndefiniteLength, a(Self))
  else
    Result := a(Self);
end;

function TCbor_UTF8.GetAsBytes: TArray<TBytes>;
var b: TBytes;
begin
  for var s in FValue do begin
    b := TEncoding.UTF8.getbytes(s);
    Result := Result + [TCbor.Encode(Length(b), cborUTF8, False, b)];
  end;
end;

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): TCborItem;
begin
  Result.FValue := a.Encode_UTF8;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_UTF8.Implicit(aCbor: TCborItem): TCbor_UTF8;
begin
  var d := TCbor.Create(aCbor.FValue);
  if d.Next then
    Result := d.AsUTF8;
end;

class operator TCbor_UTF8.Implicit(a: TCbor_UTF8): string;
begin
  if not a.FIsIndefiniteLength then
    Result := a.Value[0]
  else begin
    Result := '(_ ';
    for var i := 0 to Length(a.Value) - 2 do
      Result := Result + '"' + a.Value[i] + '", ';
    Result := Result + '"' + a.Value[Length(a.Value) - 1] + '")';
  end;
end;

{ TCbor_Array }

constructor TCbor_Array.Create(V: TArray<TCborItem>; aIsIndefiniteLength:
    Boolean = false);
begin
  FValue := V;
  FIsIndefiniteLength := aIsIndefiniteLength;
  FType := cborArray;
end;

function TCbor_Array.Encode_Array: TBytes;
begin
  var a := Function(aArr: TCbor_Array): TBytes
  begin
    for var i in aArr.FValue do
      Result := Result + i.Value;
  end;

  Result := TCbor.Encode(Length(FValue), FType, FIsIndefiniteLength, a(Self));
end;

function TCbor_Array.GetCount: Integer;
begin
  Result := Length(FValue);
end;

function TCbor_Array.GetValues(Index: Integer): TCBorItem;
begin
  Result := FValue[Index];
end;

class operator TCbor_Array.Implicit(a: TCbor_Array): TCborItem;
begin
  Result.FValue := a.Encode_Array;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_Array.Implicit(aCbor: TCborItem): TCbor_Array;
begin
  var a := TCbor(aCbor.FValue);
  if a.Next then
    Result := a.AsArray;
end;

{ TCbor_Map }

constructor TCbor_Map.Create(V: TArray<TPair<TCborItem, TCborItem>>;
    aIsIndefiniteLength: Boolean = false);
begin
  FValue := V;
  FIsIndefiniteLength := aIsIndefiniteLength;
  FType := cborMap;
end;

function TCbor_Map.ContainsKey(aKey: String): Boolean;
begin
  Result := IndexOf(aKey) >= 0;
end;

function TCbor_Map.ContainsKey(aKey: Int64): Boolean;
begin
  for var i in FValue do
    if (i.Key.cborType = cborUnsigned) or (i.Key.cborType = cborSigned) then
      if Int64(i.Key) = aKey then
         Exit(True);
  Result := False;
end;

function TCbor_Map.ContainsKey(aKey: String; out Index: Integer): Boolean;
begin
  Index := IndexOf(aKey);
  Result := Index >= 0;
end;

function TCbor_Map.ContainsKey(aKey: UInt64): Boolean;
begin
  for var i in FValue do
    if i.Key.cborType = cborUnsigned then
      if UInt64(TCbor_UInt64(i.Key)) = aKey then
         Exit(True);
  Result := False;
end;

function TCbor_Map.Encode_Map: TBytes;
begin
  var a := Function(aMap : TCbor_Map): TBytes
  begin
    for var i in aMap.FValue do
      Result := Result + i.Key.Value + i.Value.Value;
  end;

  Result := TCbor.Encode(Length(FValue), FType, FIsIndefiniteLength, a(Self));
end;

function TCbor_Map.GetCount: Integer;
begin
  Result := Length(FValue);
end;

function TCbor_Map.ValueByKey(aKey: String): TCborItem;
begin
  var i : Integer;
  Assert(ContainsKey(aKey, i), 'Key not found in map.');
  Result := FValue[i].Value;
end;

function TCbor_Map.ValueByKey(aKey: Int64): TCborItem;
begin
  for var i in FValue do
    if (i.Key.cborType = cborUnsigned) or (i.Key.cborType = cborSigned) then
      if Int64(i.Key) = aKey then
        Exit(i.Value);
  Assert(False, 'Key not found in map.');
end;

function TCbor_Map.ValueByKey(aKey: UInt64): TCborItem;
begin
  for var i in FValue do
    if (i.Key.cborType = cborUnsigned) then
      if TCbor_UInt64(i.Key).Value = aKey then
        Exit(i.Value);
  Assert(False, 'Key not found in map.');
end;

function TCbor_Map.GetValues(IndexOrName: OleVariant): TPair<TCborItem,
    TCborItem>;
begin
  if VarType(IndexOrName) = varInteger then
     Result := FValue[Integer(IndexOrName)]
  else
     Result := FValue[IndexOf(IndexOrName)];
end;

function TCbor_Map.IndexOf(aKey: String): Integer;
begin
  Result := -1;
  for var i := 0 to Length(FValue) - 1 do
    if (FValue[i].Key.cborType = cborByteString) or (FValue[i].Key.cborType = cborUTF8) then
      if FValue[i].Key = aKey then
        Exit(i);
end;

class operator TCbor_Map.Implicit(a: TCbor_Map): TCborItem;
begin
  Result.FValue := a.Encode_map;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := a.FIsIndefiniteLength;
end;

class operator TCbor_Map.Implicit(aCbor: TCborItem): TCbor_Map;
begin
  var a := TCbor(aCbor.FValue);
  if a.Next then
    Result := a.AsMap;
end;

{ TCborItem }

function TCborItem.GetValueCount: Integer;
begin
  var a := TCbor(FValue);
  if a.Next then
    Result := a.DataItemSize
  else
    Result := -1;
end;

class operator TCborItem.Implicit(a: TCborItem): Extended;
begin
  var c := TCbor.Create(a.FValue);
  Assert((c.Next and (a.cborType = cborSpecial)), 'Invalid conversion.');
  Result := c.AsSpecial;
end;

class operator TCborItem.Implicit(a: TCborItem): Boolean;
begin
  var c := TCbor.Create(a.FValue);
  Assert((c.Next and (a.cborType = cborSpecial)), 'Invalid conversion.');
  Result := c.AsSpecial;
end;

function TCborItem.GetPayload: TBytes;
begin
  SetLength(Result, PayloadCount);
  Result := Copy(FValue, ValueCount - PayloadCount, PayloadCount);
end;

function TCborItem.GetPayloadCount: Integer;
begin
  var a := TCbor(FValue);
  if a.Next then
     Result := a.DataItemSize - a.ExtendedCount - 1
  else
     Result := 0;
end;

function TCborItem.SameAs(aCbor: TCborItem): Boolean;
begin
  Result := False;
  if PayloadCount = aCbor.PayloadCount then begin
    Result := True;
    for var i := 0 to PayloadCount -1 do begin
      if FValue[i] <> aCbor.FValue[i] then
        Result := False;
      break;
    end;
  end;
end;

class operator TCborItem.Implicit(a: TCborItem): string;
begin
  var c := TCbor.Create(a.FValue);
  if c.Next then
    if a.cborType = cborByteString then
      Result := c.AsByteString
    else if a.cborType = cborUTF8 then
      Result := c.AsUTF8
    else if a.cborType = cborSpecial then
      Result := c.AsSpecial
    else raise Exception.CreateFmt('Invalid conversion from major type %d to string', [Ord(a.cborType)])
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCborItem.Implicit(a: TCborItem): Int64;
begin
  var c := TCbor.Create(a.FValue);
  if c.Next and (a.cborType = cborSigned) then
     Result := c.AsInt64.Value
  else if a.cborType = cborUnsigned then
     Result := Int64(c.AsUInt64.Value)
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCborItem.Implicit(a: TCborItem): Variant;
begin
  var c := TCbor.Create(a.FValue);
  Assert((c.Next and (a.cborType = cborSpecial)), 'Invalid conversion.');
  Result := c.AsSpecial;
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
var base : Integer;
begin
  // for decimal and big float
  if a.FTag = decimal then
    base := 10
  else if a.FTag = bigFloat then
    base := 2
  else raise Exception.CreateFmt('Unsupported tag: %d', [Ord(a.FTag)]);

  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value) - 1));
  c.FIndex := 0;
  var arr := c.AsArray.FValue;
  var arrInt64 := TArray<Int64>.Create();
  for var i := 0 to 1 do
    if arr[i].CborType = cborUnsigned then
      arrInt64 := arrInt64 + [TCbor_UInt64(arr[i]).Value]
    else if arr[i].CborType = cborSigned then
      arrInt64 := arrInt64 + [TCbor_Int64(arr[i]).Value]
    else
      raise Exception.Create('Invalid conversion.');

  Result := arrInt64[1] * Power(base, arrInt64[0]);
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): string;
var t, c : TCbor;
begin
  t := TCbor.Create(a.Value);
  if t.Next then
    c := TCbor.Create(Copy(a.Value, t.ExtendedCount + 1, Length(a.Value) - t.ExtendedCount - 1));

  if not c.Next then raise Exception.Create('No data load');

  if c.DataType = cborByteString then begin
    if (a.FTag = positiveBigNum) or (a.FTag = negativeBigNum) then
      Assert(False, 'To be implemented: Big Number');
    Result := c.AsByteString.AsString[0];
  end
  else if c.DataType = cborUTF8 then
    Result := c.AsUTF8.Value[0]
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): TCborItem;
begin
  Result.FValue := a.Encode_Semantic;
  Result.FType := a.FType;
  Result.FIsIndefiniteLength := false;
end;

class operator TCbor_Semantic.Implicit(aCbor: TCborItem): TCbor_Semantic;
begin
  var a := TCbor(aCbor.FValue);
  if a.Next and (a.DataType = cborSemantic) then
    Result := a.AsSemantic
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): Int64;
begin
  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value)-1));
  if c.Next and (c.DataType = cborSigned) then
    Result := c.AsInt64.Value
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): UInt64;
begin
  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value)-1));
  if c.Next and (c.DataType = cborUnsigned) then
    Result := c.AsUInt64.Value
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCbor_Semantic.Implicit(a: TCbor_Semantic): Extended;
begin
  var c := TCbor.Create(Copy(a.Value, 1, Length(a.Value)-1));
  if c.Next then
    Result := c.AsSpecial
  else raise Exception.Create('Invalid conversion.');
end;

{ TCbor_Special }

constructor TCbor_Special.Create(V: TBytes; T: TCborSpecialTag);
begin
  FValue := V;
  FTag := T;
  FType := cborSpecial;
end;

class operator TCbor_Special.Implicit(aCbor: TCborItem): TCbor_Special;
begin
  var a := TCbor(aCbor.FValue);
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
  if a.FTag = cborFalse then
    Result := False
  else if a.FTag = cborTrue then
    Result := True
  else
    raise Exception.Create('Tag unmatched.');
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): Extended;
var Pow2: TArray<Int64>;
    exponent, mantissa: Extended;
begin
  if (Ord(a.FTag) < Ord(TCborSpecialTag.cbor16bitFloat)) or (Ord(a.FTag) > Ord(TCborSpecialTag.cbor64bitFloat))
    then raise Exception.Create('Tag unmatched.');

  for var i := 0 to 63 do Pow2 := Pow2 + [Int64(1) shl i];

  var BinaryBits := TBits.Create();
  exponent := 0;
  mantissa := 0;
  var exponentLength := 2 + 3 * (Ord(a.FTag) - 24);    // 5, 8, 11
  try
    BinaryBits.Size := pow2[Ord(a.FTag) - 21];           // 2, 4, 8

    for var i := 1 to (BinaryBits.Size div 8) do begin
      if a.FValue[i] = 0 then
        for var j := 0 to 7 do
          BinaryBits.Bits[8*(i-1) + j] := False
      else begin
        var b := a.Value[i];
        for var k := 7 downto 0 do begin
          BinaryBits[k + 8*(i-1)] := (b and 1).ToBoolean;
          b := b shr 1;
        end;
      end;
    end;

    for var i := exponentLength downto 1 do
      if BinaryBits[i] then
        exponent := exponent + Pow2[exponentLength-i];
    exponent := exponent - (Pow2[exponentLength - 1] - 1);  // subtract bias

    for var i := BinaryBits.Size-1 downto exponentLength+1 do begin
      if BinaryBits[i] then
        mantissa := mantissa + Pow2[BinaryBits.Size-1-i];
    end;

    if (exponent = Pow2[exponentLength-1]) then begin   // Check for positive/negative infinity and NaN
      if mantissa = 0 then
        if not BinaryBits[0] then Exit(Infinity)
        else Exit(NegInfinity)
      else
        Exit(NaN);
    end;

    if exponent = -(Pow2[exponentLength-1]-1) then begin
      if mantissa = 0 then
        if not BinaryBits[0] then Exit(0)
        else Exit(-0);
      exponent := exponent + 1;
      mantissa := mantissa / Pow2[BinaryBits.Size-exponentLength-1];
    end else
      mantissa := 1 + mantissa / Pow2[BinaryBits.Size-exponentLength-1];

    Result := Power(2, exponent) * mantissa * (-2 * BinaryBits[0].ToInteger + 1);

    if pos('.', FloatToStr(Result)) = 0 then
      Result := RoundTo(Result, -1);                       // for XX.0 format
  finally
    BinaryBits.Free;
  end;
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): Variant;
begin
  if a.FTag = cborNull then Result := Null
  else raise Exception.Create('Invalid conversion.');
end;

class operator TCbor_Special.Implicit(a: TCbor_Special): string;
begin
  Assert((a.FTag = cborSimple) or (a.FTag = cborUndefined), 'Tag unmatched.');
  
  var s := a.Value[0] and TCbor.ShortCountBit;
  if s < TCbor.MaxShortCount then
    Result := 'simple(' + IntToStr(s) + ')'
  else if s = TCbor.MaxShortCount then
    Result := 'undefined'
  else if s = TCbor.MaxShortCount + 1 then
    Result := 'simple(' + IntToStr(a.Value[1]) + ')'
  else raise Exception.Create('Invalid conversion.');
end;

end.
