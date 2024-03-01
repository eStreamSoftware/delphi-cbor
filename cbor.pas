unit cbor;

interface

uses System.SysUtils;

const
  Map = 5;

type
  TCborDataType = (cborUnsigned = 0, cborSigned = 1, cborByteString = 2, cborUTF8 = 3, cborArray = 4, cborMap = 5, cborSemantic = 6, cborSpecial = 7);

  TCborDataItem = record
    aType: TCborDataType;
    aValue: TBytes;
  end;

  TCborDataItems = TArray<TCborDataItem>;

  TCbor = record
  private
    FData: TBytes;
    FIndex: Integer;
    function GetLittleEndian(Index, Count: Cardinal): UInt64;
  public
    constructor Create(aValue: TBytes);
    function AsByteString: string;
    function AsInt64: Int64;
    function AsUInt64: UInt64;
    function DataItemSize: UInt64;
    function DataType: TCborDataType;
    function Next: Boolean;
    procedure Reset;
    class operator Implicit(Value: TBytes): TCbor;
  end;

implementation

constructor TCbor.Create(aValue: TBytes);
begin
  Reset;
  FData := Copy(aValue, 0, Length(aValue));
end;

function TCbor.AsByteString: string;
begin
  var s := DataItemSize;
  if s <= 23 then
    Result := TEncoding.ANSI.GetString(FData, FIndex + 1, s - 1);
end;

function TCbor.AsInt64: Int64;
begin
  Result := -1 - AsUInt64;
end;

function TCbor.AsUInt64: UInt64;
begin
  var s := DataItemSize;
  if s = 1 then
    Result := FData[FIndex] and $1F
  else
    Result := GetLittleEndian(FIndex + 1, s - 1);
end;

function TCbor.DataItemSize: UInt64;
begin
  Result := 1;
  var A := TArray<Byte>.Create(0, 1, 2, 4, 8);
  case DataType of
    cborUnsigned, cborSigned: begin
      var i := FData[FIndex] and $1F;
      if i <= 23 then i := 23;
      Inc(Result, A[i - 23]);
    end;
    cborByteString: begin
      var i := FData[FIndex] and $1F;
      if i <= 23 then
        Inc(Result, i)
      else
        Inc(Result, GetLittleEndian(FIndex + 1, A[i - 23]));
    end
    else
      raise Exception.CreateFmt('Unsupported data type: %d', [Byte(DataType)]);
  end;
end;

function TCbor.DataType: TCborDataType;
begin
  Result := TCborDataType(FData[FIndex] shr 5);
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

function TCbor.GetLittleEndian(Index, Count: Cardinal): UInt64;
begin
  var R := TArray<Byte>.Create(0, 0, 0, 0, 0, 0, 0, 0);
  var j := 0;
  for var i := Index + Count - 1 downto Index do begin
    R[j] := FData[i];
    Inc(j);
  end;
  Move(R[0], Result, Length(R));
end;

class operator TCbor.Implicit(Value: TBytes): TCbor;
begin
  Result := TCbor.Create(Value);
end;

end.
