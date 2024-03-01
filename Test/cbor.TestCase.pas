unit cbor.TestCase;

interface

uses
  TestFramework;

type
  TTestCase_cbor = class(TTestCase)
  private
  published
    procedure Test_Unsigned_0;
    procedure Test_Unsigned_8;
    procedure Test_Unsigned_16;
    procedure Test_Unsigned_32;
    procedure Test_Unsigned_64;
    procedure Test_Signed_0;
    procedure Test_Signed_8;
    procedure Test_Signed_16;
    procedure Test_Signed_32;
    procedure Test_Signed_64;
    procedure Test_ByteString_0;
    procedure Test_ByteString_1;
    procedure Test_ByteString_2;
  end;

implementation

uses System.SysUtils, cbor;

procedure TTestCase_cbor.Test_Signed_16;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f, $39, $0a, $0f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(-53872, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(-2576, c.AsInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_0;
begin
  var c: TCbor := TBytes.Create($4b, $48, $65, $6c, $6c, $6f, $20, $57, $6f, $72, $6c, $64);

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(12, c.DataItemSize);
  CheckEquals('Hello World', c.AsByteString);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_1;
begin

end;

procedure TTestCase_cbor.Test_ByteString_2;
begin
  var c: TCbor := TBytes.Create(
    $78, $F5, $49, $6E, $20, $74, $68, $65, $20, $62, $65, $67, $69, $6E, $6E, $69
  , $6E, $67, $20, $47, $6F, $64, $20, $63, $72, $65, $61, $74, $65, $64, $20, $74
  , $68, $65, $20, $68, $65, $61, $76, $65, $6E, $73, $20, $61, $6E, $64, $20, $74
  , $68, $65, $20, $65, $61, $72, $74, $68, $2E, $0D, $0A, $4E, $6F, $77, $20, $74
  , $68, $65, $20, $65, $61, $72, $74, $68, $20, $77, $61, $73, $20, $66, $6F, $72
  , $6D, $6C, $65, $73, $73, $20, $61, $6E, $64, $20, $65, $6D, $70, $74, $79, $2C
  , $20, $64, $61, $72, $6B, $6E, $65, $73, $73, $20, $77, $61, $73, $20, $6F, $76
  , $65, $72, $20, $74, $68, $65, $20, $73, $75, $72, $66, $61, $63, $65, $20, $6F
  , $66, $20, $74, $68, $65, $20, $64, $65, $65, $70, $2C, $20, $61, $6E, $64, $20
  , $74, $68, $65, $20, $53, $70, $69, $72, $69, $74, $20, $6F, $66, $20, $47, $6F
  , $64, $20, $77, $61, $73, $20, $68, $6F, $76, $65, $72, $69, $6E, $67, $20, $6F
  , $76, $65, $72, $20, $74, $68, $65, $20, $77, $61, $74, $65, $72, $73, $2E, $0D
  , $0A, $41, $6E, $64, $20, $47, $6F, $64, $20, $73, $61, $69, $64, $2C, $20, $4C
  , $65, $74, $20, $74, $68, $65, $72, $65, $20, $62, $65, $20, $6C, $69, $67, $68
  , $74, $2C, $20, $61, $6E, $64, $20, $74, $68, $65, $72, $65, $20, $77, $61, $73
  , $20, $6C, $69, $67, $68, $74, $2E
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(261, c.DataItemSize);
  CheckEquals('''
  In the beginning God created the heavens and the earth.
  Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.
  And God said, Let there be light, and there was light.
  '''
  , c.AsByteString
  );

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_0;
begin
  var c: TCbor := TBytes.Create($20, $21, $22, $37);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-1, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-2, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-3, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-24, c.AsInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_64;
begin
  var c: TCbor := TBytes.Create(
    $3b, $00, $00, $05, $55, $83, $80, $50, $1a
  , $3b, $00, $02, $8e, $9e, $bb, $b6, $c7, $4a
  );

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals(-5864836583451, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals(-719762358716235, c.AsInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_32;
begin
  var c: TCbor := TBytes.Create($3a, $00, $17, $79, $a7, $3a, $00, $31, $53, $3f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-1538472, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-3232576, c.AsInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_8;
begin
  var c: TCbor := TBytes.Create($38, $18, $38, $19);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-25, c.AsInt64);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-26, c.AsInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_0;
begin
  var c: TCbor := TBytes.Create($00, $01, $17);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(0, c.AsUInt64);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(1, c.AsUInt64);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(23, c.AsUInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_8;
begin
  var c: TCbor := TBytes.Create($18, $EB);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(235, c.AsUInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_16;
begin
  var c: TCbor := TBytes.Create($19, $30, $3B);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(12347, c.AsUInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_32;
begin
  var c: TCbor := TBytes.Create($1A, $00, $03, $A9, $80);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(240000, c.AsUInt64);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_64;
begin
  var c: TCbor := TBytes.Create($1B, $00, $1F, $E0, $22, $99, $A3, $8B, $8C);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals(8972163489172364, c.AsUInt64);

  CheckFalse(c.Next);
end;

initialization
  RegisterTest(TTestCase_cbor.Suite);
end.
