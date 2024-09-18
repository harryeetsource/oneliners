gci -r -fi *.asm | % { $d = Join-Path "C:\bill" $_.FullName.Substring((pwd).Path.Length); ni -it di (Split-Path $d) -fo; cp $_.FullName $d -fo }
