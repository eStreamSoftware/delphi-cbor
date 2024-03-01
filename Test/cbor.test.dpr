program cbor.test;

uses
  FastMM5,
  {$ifdef TestInsight}TestInsight.DUnit,{$endif}
  {$ifndef TestInsight}DUnitTestRunner,{$endif}
  cbor.TestCase in 'cbor.TestCase.pas',
  cbor in '..\cbor.pas',
  numbers in 'numbers.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  RunRegisteredTests;
end.


