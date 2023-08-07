<?php
	$f = fopen("tables.txt", "w");

	// part of videolines table in PPU
	//
	fputs($f, "\nVLinesTable:\n");
	$vaddr = 0100000;
	$paddr_start = 01130;
	$paddr = $paddr_start + 4;
	$col = 0;
	$count = 384;
	for ($i=0; $i<$count; $i++)
	{
		if ($col == 0) fputs($f, "\t.word\t");
		fputs($f, decoct($vaddr) . "," . decoct($paddr));
		$vaddr += 40;
		$paddr += 4;
		if ($col != 15  && $i < ($count-1)) { fputs($f, ", "); $col++; } else { fputs($f, "\n"); $col = 0; }
	}
	fputs($f, "\t.word\t" . decoct($vaddr) . "," . decoct($paddr-4) . "\n");

	fclose($f); 
